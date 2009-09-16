
require('aurita')

require('stringio')
require('observer')

Aurita.import(:base, :attributes)
Aurita.import(:base, :session)
Aurita.import(:base, :exceptions)
Aurita.import(:base, :log, :class_logger)
Aurita.import(:base, :bits, :cgi)
Aurita.import(:base, :plugin_register)
Aurita.import_module :decorators, :default
Aurita.import_module :gui, :error_page

require('lore/exceptions/validation_failure')
require('lore/exceptions/unknown_type')
require('lore/validation/parameter_validator')
require('lore')


class Aurita::Dispatcher 

  attr_reader :params, :mode, :controller, :action, :dispatch_time, :failed, :response_header, :response_body, :status
  attr_accessor :gc_after_dispatches, :decorator

  public

  # Usage: 
  #
  #  require('my_app/application')
  #  dispatcher = Dispatcher.new(My_App::Application,     # Register your app
  #                              My_App::Custom_Decoator) # Define which template klass to use for output
  #
  def initialize(application=Aurita::Main::Application, 
                 decorator=Aurita::Main::Default_Decorator)
    @application         = application
    @decorator           = decorator
    @logger              = Aurita::Log::Class_Logger.new('Dispatcher')
    @gc_after_dispatches = 500

    @params              = {}
    @response_header     = {}
    @response_body       = ''
    @mode                = false
    @controller          = false
    @action              = false
    @dispatch_time       = 0.0
    @failed              = false
    @num_dispatches      = 0 
  end

  # Dispatch given request to a controller method, and 
  # handles its response (e.g. by rendering it), which then 
  # is stored in this Dispatcher's @response. 
  #
  # Expects instance of Rack::Request. 
  #
  def dispatch(request)
  # {{{
    @dispatch_time     = 0.0
    @request           = request
    @params            = Aurita::Attributes.new(request)
    @session           = Aurita::Session.new(request)
    @mode              = params[:mode]
    @controller        = params[:controller]
    @action            = params[:action]
    @params[:_request] = @request
    @params[:_session] = @session
    @failed            = false
    @status            = 200

    @controller ||= 'App_Main'
    @action     ||= 'start'
    @mode       ||= 'default'

    Thread.current['request'] = @params

    @response_header = {}
    @response_header['Accept-Charset'] = 'utf-8' 
    @response_header['type']           = 'text/html; charset=utf-8' 
    @response_header['expires']        = (Time.now - (1 * 24 * 60 * 60)).to_s
    @response_header['pragma']         = 'No-cache'

    Lore::Connection.reset_query_count()
    Lore::Connection.reset_result_row_count()

    benchmark_time = Time.now

    begin
      raise ::Exception.new('No controller given') if(@controller.nil? || @controller == '') 

      @model_klass      = @application.get_model_klass(@controller)
      @controller_klass = @application.get_controller_klass(@controller)

      raise ::Exception.new('Unknown controller: ' << @controller.inspect) unless @controller_klass
      
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
            # TODO: 
            # if Aurita.server.allows_x_sendfile then
            filename = response[:file]
            filesize = File.size(filename)
            if false then
              # For FCGI dispatcher without using X-Sendfile, this was: 
              # cgi_output(File.open(response[:file], "rb").read)
              @logger.log("Sending file: #{filename}")
              @logger.log("Filesize: #{filesize}")
              @response_header['Content-Type'] = "application/force-download" 
              @response_header['Content-Disposition'] = "attachment; filename=\"#{File.basename(filename)}\"" 
              @response_header["X-Aurita-Sendfile"] = filename
              # Use X-Content-length, as Content-length will be overwritten 
              # by Rack::ContentLength, which determines value from size of 
              # response body. 
              @response_header['X-Content-Length'] = filesize
              @response_header['Content-Length']   = filesize
              @response_body = ''
              return
            else 
              @response_header['X-Content-Length'] = filesize
              @response_header['Content-Length']   = filesize
              @response_body = File.open(filename, "r").read
            end
          else
            length = @response_body.to_s.length
            @response_header['Content-Length'] = length.to_s
          end
        rescue ::Exception => failed
          @failed = true
          @status = 200
          response = { :error => GUI::Error_Page.new(failed).string }
          @logger.log { "Error in Dispatcher: #{failed.message}" }
          @logger.log { "#{failed.backtrace.join("\n")}" }
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
      @response_header['etag'] = Digest::MD5.hexdigest(output) if output
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
                                   :dispatcher  => self, 
                                   :controller  => controller_instance, 
                                   :action      => @action, 
                                   :time        => @benchmark_time, 
                                   :num_queries => @num_queries, 
                                   :num_tuples  => @num_tuples)

    rescue Exception => excep
      @logger.log(excep.message)
      @logger.log(excep.backtrace.join("\n"))
      @response_body = { :error => GUI::Error_Page.new(excep).string }
    end

  end # def }}}

  def response_header
    @response_header.each_pair { |k,v| @response_header[k] = v.to_s }
    @response_header
  end

end # class

