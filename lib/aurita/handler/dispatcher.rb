
require('aurita')

Aurita.import(:base, :attributes)
Aurita.import(:base, :session)
Aurita.import(:base, :exceptions)
Aurita.import(:base, :log, :class_logger)
Aurita.import(:base, :plugin_register)
Aurita.import_module :decorators, :default
Aurita.import_module :gui, :error_page

require('lore/exceptions/validation_failure')
require('lore/exceptions/unknown_type')
require('lore/validation/parameter_validator')
require('lore')


class Aurita::Dispatcher 

  attr_reader :params, :mode, :controller, :action, :benchmark_time, :num_dispatches, :logger
  attr_accessor :decorator, :poller

  public

  # Usage: 
  #
  #  require('my_app/application')
  #  dispatcher = Aurita::Dispatcher.new(My_App::Application)
  #
  def initialize(application=Aurita::Main::Application)
    @application         = application
    @decorator           = Aurita::Main::Default_Decorator.new
    @logger              = Aurita::Log::Class_Logger.new('Dispatcher')
    @benchmark_time      = 0
    @num_dispatches      = 0 
    @poller              = false
  end

  # Dispatch given request to a controller method, and 
  # handles its response (e.g. by rendering it), which then 
  # is stored in this Dispatcher's @response. 
  #
  # Expects instance of Rack::Request. 
  #
  def dispatch(request)
  # {{{
    benchmark_start_time = Time.now unless @poller

    params                = Aurita::Attributes.new(request)
    params[:_request]     = request
    params[:_session]     = Aurita::Session.new(request)
    params[:_application] = @application
    status                = 200
    response_body         = ''
    response_header       = {}

    controller            = params[:controller]
    action                = params[:action]
    mode                  = params[:mode]
    controller          ||= 'App_Main'
    action              ||= 'start'
    mode                ||= 'default'

    Thread.current['request'] = params

    Lore::Connection.reset_query_count()
    Lore::Connection.reset_result_row_count()

    begin
      raise ::Exception.new('No controller given') if(controller.nil? || controller == '') 

      model_klass      = @application.get_model_klass(controller)
      controller_klass = @application.get_controller_klass(controller)

      raise ::Exception.new('Unknown controller: ' << controller.inspect) unless controller_klass
      
      controller_instance = controller_klass.new(params, model_klass)

      response = false
      @logger.log("Calling model interface method #{controller}.#{action}")
      begin
        if @poller then
          element = controller_instance.call_unguarded(action)
        else 
          element = controller_instance.call_guarded(action)
        end
        response = controller_instance.response
        if response[:html] == '' then
          if element.respond_to?(:string) then
            response[:html] = element.string 
          elsif element.is_a?(Array) then
            element.each { |e|
              response[:html] << e.to_s
            }
          end
        end

        response_header.update(response[:http_header]) if response[:http_header]
      rescue ::Exception => excep
        @logger.log { "Error in Dispatcher: #{excep.message}" }
        @logger.log { "#{excep.backtrace.join("\n")}" }
        raise excep
      end

      mode                 = response[:mode].to_sym if response && response[:mode]
      mode               ||= :default 
      response[:mode]      = mode
      params[:_controller] = controller_instance

      response_body = @decorator.render(model_klass, response, params)

      @num_dispatches += 1

      if !@poller then
        @benchmark_time = Time.now-benchmark_start_time
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
      end
    rescue Exception => excep
      @logger.log(excep.message)
      @logger.log(excep.backtrace.join("\n"))
      response_body = GUI::Error_Page.new(excep).string
    end

    return [ status, response_header, response_body ]
  end # def }}}

end # class

