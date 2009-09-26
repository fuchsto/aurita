
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

  attr_reader :params, :mode, :controller, :action, :dispatch_time
  attr_accessor :decorator

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
    @decorator           = decorator.new
    @logger              = Aurita::Log::Class_Logger.new('Dispatcher')
    @benchmark_time      = 0
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
    dispatch_time     = 0.0
    params            = Aurita::Attributes.new(request)
    session           = Aurita::Session.new(request)
    params[:_request] = request
    params[:_session] = session
    status            = 200
    response_body     = ''
    response_header   = {}

    controller        = params[:controller]
    action            = params[:action]
    mode              = params[:mode]
    controller      ||= 'App_Main'
    action          ||= 'start'
    mode            ||= 'default'

    Thread.current['request'] = params

    response_header['Accept-Charset'] = 'utf-8' 
    response_header['type']           = 'text/html; charset=utf-8' 
    response_header['Cache-Control']  = 'private'

    Lore::Connection.reset_query_count()
    Lore::Connection.reset_result_row_count()

    benchmark_time = Time.now

    begin
      raise ::Exception.new('No controller given') if(controller.nil? || controller == '') 

      model_klass      = @application.get_model_klass(controller)
      controller_klass = @application.get_controller_klass(controller)

      raise ::Exception.new('Unknown controller: ' << controller.inspect) unless controller_klass
      
      controller_instance = controller_klass.new(params, model_klass)

      response = false
      if !controller_klass.nil?
        @logger.log("Calling model interface method #{controller}.#{action}")
        begin
          element           = controller_instance.call_guarded(action)
          response          = controller_instance.response
          response_header.update(response[:http_header]) if response[:http_header]
          response[:html]   = element.string if (element.respond_to?(:string) && response[:html] == '')
          if response[:file] then
            filename = response[:file]
            filesize = File.size(filename)
            response_header['Content-Type']        = "application/force-download" 
            response_header['Content-Disposition'] = "attachment; filename=\"#{File.basename(filename)}\"" 
            response_header['Content-Length']      = filesize
            response_header["X-Aurita-Sendfile"]   = filename
            response_header["X-Aurita-Filesize"]   = filesize
            response_body = ''

            return [ status, response_header, response_body ]
          end
        rescue ::Exception => excep
          status = 200
          response = { :error => GUI::Error_Page.new(excep).string }
          @logger.log { "Error in Dispatcher: #{excep.message}" }
          @logger.log { "#{excep.backtrace.join("\n")}" }
        end
      end

      if response[:force_cache] then
        response_header['expires']       = (Time.now + (100 * 24 * 60 * 60)).to_s
        response_header['Last-Modified'] = (Time.now - (1 * 24 * 60 * 60)).to_s
      else
        response_header['expires']       = (Time.now - (1 * 24 * 60 * 60)).to_s
        response_header['pragma']        = 'No-cache'
      end

      mode = response[:mode] if response && response[:mode]
      mode = :default unless mode
      response[:mode] = mode.intern 

      params[:_controller] = controller_instance

      response_body = @decorator.render(model_klass, response, params)

      @num_dispatches += 1
        
      @benchmark_time = Time.now-benchmark_time
      @num_queries    = Lore::Connection.query_count
      @num_tuples     = Lore::Connection.result_row_count

      Aurita::Plugin_Register.call(Hook.dispatcher.request_finished, 
                                   controller_instance, 
                                   :dispatcher  => self, 
                                   :controller  => controller_instance, 
                                   :action      => action, 
                                   :time        => @benchmark_time, 
                                   :num_queries => @num_queries, 
                                   :num_tuples  => @num_tuples)

    rescue Exception => excep
      @logger.log(excep.message)
      @logger.log(excep.backtrace.join("\n"))
      response_body = { :error => GUI::Error_Page.new(excep).string }
    end

    response_header.each_pair { |k,v| response_header[k] = v.to_s }
    return [ status, response_header, response_body ]
  end # def }}}

end # class

