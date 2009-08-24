
require('aurita')

require('stringio')
require('observer')

Aurita.import(:base, :attributes)
Aurita.import(:base, :exceptions)
Aurita.import(:base, :log, :class_logger)
Aurita.import(:base, :bits, :cgi)
Aurita.import(:base, :plugin_register)
Aurita.import_module :session
Aurita.import_module :decorators, :default

require('lore/exceptions/validation_failure')
require('lore/validation/parameter_validator')
require('lore')

begin 
  require 'zlib' 
  require 'stringio' 
  GZIP_SUPPORTED = false
rescue 
  GZIP_SUPPORTED = false 
end 


class Aurita::Dispatcher 
include Observable

  attr_reader :params, :mode, :controller, :action, :dispatch_time, :failed
  attr_accessor :gc_after_dispatches, :decorator

  private

  def cgi_output(content)
    if use_gzip? then
      output = StringIO.new 
      def output.close 
        # Zlib does a close instead of rewind. Bad Zlib... 
        rewind 
      end 
      gz = Zlib::GzipWriter.new(output) 
      gz.write(content) 
      gz.close 
      content = output.string
      @response_header['Content-encoding'] = use_gzip? unless @response_header['Content-encoding']
    end
    @cgi.out(@response_header) { content }
  end

  def use_gzip?
    return false # unless GZIP_SUPPORTED 
    accepts = @cgi.env_table['HTTP_ACCEPT_ENCODING'] if @cgi.respond_to? :env_table
    return false unless accepts && accepts =~ /(x-gzip|gzip)/ 
    # TODO: This can't possibly be thread safe?!
    return $1  # Last regex match
  end

  public

  # Usage: 
  #
  #  require('my_app/[<module>/]application')
  #  dispatcher = Dispatcher.new(My_App::[<Module>::]Application,    # Register your app
  #                              My_App_Namespace::Interface,        # Tell dispatcher from where to load app interfaces
  #                              My_App_Namespace::Custom_Template)  # Define which template klass to use for output
  #
  def initialize(application=Aurita::Main::Application, 
                 controller_ns=Aurita::Main, 
                 decorator=Aurita::Main::Default_Decorator)
    @application           = application
    @controller_namespace  = controller_ns
    @decorator             = decorator
    @logger                = Aurita::Log::Class_Logger.new('Dispatcher')
    @gc_after_dispatches   = 500

    @params                = {}
    @response_header       = {}
    @mode                  = false
    @controller            = false
    @action                = false
    @dispatch_time         = 0.0
    @failed                = false
    @num_dispatches        = 0 
  end

  # Dispatch given CGI request to controller call. 
  # Expects CGI request object. 
  #
  def dispatch(cgi)
  # {{{
    @dispatch_time = 0.0
    @cgi           = cgi
    @params        = Aurita::Attributes.new(cgi)
    @mode          = params[:mode]
    @controller    = params[:controller]
    @action        = params[:action]
    @failed        = false
    @session       = Aurita::Session.new(cgi)
    @params[:_request] = @cgi
    @params[:_session] = @session

    Thread.current['request'] = @params

    @response_header = {}
    @response_header['connection']          = 'close' 
    @response_header['Accept-Charset']      = 'utf-8' 
    @response_header['type']                = 'text/html; charset=utf-8' 
    @response_header['expires']             = Time.now - (1 * 24 * 60 * 60)
    @response_header['pragma']              = 'No-cache'

    Lore::Connection.reset_query_count()
    Lore::Connection.reset_result_row_count()

    benchmark_time = Time.now

    raise ::Exception.new('No controller given') if(@controller.nil? || @controller == '') 

    begin

      begin
        @model_klass      = @application.get_model_klass(@controller)
        @controller_klass = @application.get_controller_klass(@controller)
      rescue ::Exception => excep
        raise ::Exception.new('Error when trying to load model or interface \'' << @controller + '\': ' << excep.message + "\n" << excep.backtrace.join("\n"))
      end

      raise ::Exception.new('Unknown controller: ' << @controller.inspect) unless @controller_klass
      @keys = nil

      controller_instance = @controller_klass.new(@params, @model_klass)

      hook = Hook.__send__(@controller.downcase.gsub('::','__'))
      hook = hook.__send__('before_' << action)
      Aurita::Plugin_Register.call(hook, controller_instance)

      response = false
      if !@controller_klass.nil?
        @logger.log('Calling model interface method ' << @controller + '.' << action)
        begin
          element           = controller_instance.call_guarded(action)
          response          = controller_instance.response
          @response_header.update(response[:http_header]) if response[:http_header]
          response[:html]   = element.string if (element.respond_to?(:string) && response[:html] == '')
          if response[:file] then
            cgi_output(File.open(response[:file], "rb").read)
            return
          end
        rescue ::Exception => failed
          @failed = true
          cgi_output("<h2>#{failed.message}</h2><br />#{failed.backtrace.join('<br />')}")
          # Dispatch failed, so quit
          return
        end
      end

      @mode = response[:mode] if response && response[:mode]
      @mode = :default unless @mode
      response[:mode] = @mode.to_sym
        
      if @failed then
        Aurita::Plugin_Register.call(Hook.__send__(@controller.downcase.gsub('::','__')).__send__(action + '_failed'), controller_instance)
      else
        Aurita::Plugin_Register.call(Hook.__send__(@controller.downcase.gsub('::','__')).__send__('after_' << action), controller_instance)
      end

      response[:debug]  = "Queries: #{Lore::Connection.query_count} | "
      response[:debug] << "Tuples: #{Lore::Connection.result_row_count} | "
      response[:debug] << "Time: #{Time.now-benchmark_time}"
      @params[:_controller] = controller_instance
      output = @decorator.new(@model_klass, response, @params).string
      @response_header['etag'] = Digest::MD5.hexdigest(output)
      cgi_output(output)

      @num_dispatches += 1
      if @num_dispatches >= @gc_after_dispatches then
        GC.enable
        GC.start 
        GC.disable
        @num_dispatches = 0
      end
        
      @benchmark_time = Time.now-benchmark_time
      @num_queries    = Lore::Connection.query_count
      @num_tuples     = Lore::Connection.result_row_count
      finish_request()

      Aurita::Plugin_Register.call(Hook.dispatcher.request_finished, 
                                         controller_instance, 
                                         :dispatcher => self, 
                                         :controller => controller_instance, 
                                         :action => action, 
                                         :time => @benchmark_time, 
                                         :num_queries => @num_queries, 
                                         :num_tuples => @num_tuples)

    rescue Exception => excep
      @logger.log(excep.message)
      raise excep
    ensure
      finish_request()
    end

  end # def }}}

  # Finish current CGI request. 
  #
  def finish_request
    # we need to finish the FCGI request
    req = @cgi.instance_variable_get("@request")
    req.finish if req
  end
  
end # class

