
require('aurita')

require('stringio')
require('observer')

Aurita.import(:base, :rack_attributes)
Aurita.import(:base, :rack_session)
Aurita.import(:base, :exceptions)
Aurita.import(:base, :log, :class_logger)
Aurita.import(:base, :bits, :cgi)
Aurita.import(:base, :plugin_register)
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


class Aurita::Rack_Dispatcher 
include Observable

  attr_reader :params, :mode, :controller, :action, :dispatch_time, :failed, :response_header, :response_body
  attr_accessor :gc_after_dispatches, :decorator

  public

  # Usage: 
  #
  #  require('my_app/[<module>/]application')
  #  dispatcher = Dispatcher.new(My_App::[<Module>::]Application,    # Register your app
  #                              My_App_Namespace::Interface,        # Tell dispatcher from where to load app interfaces
  #                              My_App_Namespace::Custom_Template)  # Define which template klass to use for output
  #
  def initialize(application=Aurita::Main::Application, 
                 decorator=Aurita::Main::Default_Decorator)
    @application           = application
    @decorator             = decorator
    @logger                = Aurita::Log::Class_Logger.new('Dispatcher')
    @gc_after_dispatches   = 500

    @params                = {}
    @response_header       = {}
    @response_body         = ''
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
  def dispatch(request)
  # {{{
    @dispatch_time  = 0.0
    @request        = request
    @params         = Aurita::Rack_Attributes.new(request)
    @mode           = params[:mode]
    @controller     = params[:controller]
    @action         = params[:action]
    @failed         = false
    @session        = Aurita::Rack_Session.new(request)
    @params[:_request] = @request
    @params[:_session] = @session

    if !@controller then
      p request
      uri = request.env['REQUEST_URI']
      p uri
      if !uri.include?('?') then
        uri_p = uri.split('/')
        if uri_p[1] == 'aurita' then
          @controller = uri_p[2]
          @action     = uri_p[3]
        end
      end
    end
    @controller ||= 'App_Main'
    @action     ||= 'start'
    @mode       ||= 'default'

    Thread.current['request'] = @params

    @response_header = {}
    @response_header['connection']          = 'close' 
    @response_header['Accept-Charset']      = 'utf-8' 
    @response_header['type']                = 'text/html; charset=utf-8' 
    @response_header['expires']             = (Time.now - (1 * 24 * 60 * 60)).to_s
    @response_header['pragma']              = 'No-cache'

    Lore::Connection.reset_query_count()
    Lore::Connection.reset_result_row_count()

    benchmark_time = Time.now

    begin
      raise ::Exception.new('No controller given') if(@controller.nil? || @controller == '') 

      begin
        @model_klass      = @application.get_model_klass(@controller)
        @controller_klass = @application.get_controller_klass(@controller)
      rescue ::Exception => excep
        raise ::Exception.new('Error when trying to load model or interface \'' << @controller + '\': ' << excep.message + "\n" << excep.backtrace.join("\n"))
      end

      raise ::Exception.new('Unknown controller: ' << @controller.inspect) unless @controller_klass
      @keys = nil
      
      controller_instance = @controller_klass.new(@params, @model_klass)

      Aurita::Plugin_Register.call(Hook.__send__(@controller.downcase.gsub('::','__')).__send__("before_#{@action}"), controller_instance)

      response = false
      if !@controller_klass.nil?
        @logger.log("Calling model interface method #{@controller}.#{@action}")
        begin
          element           = controller_instance.call_guarded(@action)
          response          = controller_instance.response
          @response_header.update(response[:http_header]) if response[:http_header]
          response[:html]   = element.string if (element.respond_to?(:string) && response[:html] == '')
          if response[:file] then
            cgi_output(File.open(response[:file], "rb").read)
            return
          end
        rescue ::Exception => failed
          @failed = true
          STDERR.puts("Error in Dispatcher: #{failed.message}")
          STDERR.puts("#{failed.backtrace.join("\n")}")
          # Dispatch failed, so quit
          return
        end
      end

      @mode = response[:mode] if response && response[:mode]
      @mode = :default unless @mode
      response[:mode] = @mode.intern 
        
      if @failed then
        Aurita::Plugin_Register.call(Hook.__send__(@controller.downcase.gsub('::','__')).__send__(@action + '_failed'), controller_instance)
      else
        Aurita::Plugin_Register.call(Hook.__send__(@controller.downcase.gsub('::','__')).__send__('after_' << @action), controller_instance)
      end

      @params[:_controller] = controller_instance
      output = @decorator.new(@model_klass, response, @params).string
      @response_header['etag'] = Digest::MD5.hexdigest(output)
      @response_body = output

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

      Aurita::Plugin_Register.call(Hook.dispatcher.request_finished, 
                                         controller_instance, 
                                         :dispatcher => self, 
                                         :controller => controller_instance, 
                                         :action => @action, 
                                         :time => @benchmark_time, 
                                         :num_queries => @num_queries, 
                                         :num_tuples => @num_tuples)

    rescue Exception => excep
      @logger.log(excep.message)
      @response_body = excep.message + "\n"
      @response_body << excep.backtrace.join("\n")
    end

  end # def }}}

  def response_header
    @response_header.each_pair { |k,v| @response_header[k] = v.to_s }
    @response_header
  end

end # class

