
require('aurita')

Aurita.import(:base, :attributes)
Aurita.import(:base, :session)
Aurita.import(:base, :exceptions)
Aurita.import(:base, :log, :class_logger)
Aurita.import(:base, :plugin_register)
Aurita.import(:handler, :dispatcher)
Aurita.import_module :decorators, :default
Aurita.import_module :gui, :error_page

require('lore/exceptions/validation_failure')
require('lore/exceptions/unknown_type')
require('lore/validation/parameter_validator')
require('lore')


class Aurita::Poll_Dispatcher < Aurita::Dispatcher

  attr_reader :params, :mode, :controller, :action, :benchmark_time, :num_dispatches, :logger
  attr_accessor :decorator, :poller

  public

  # Usage: 
  #
  #  require('my_app/application')
  #  dispatcher = Aurita::Poll_Dispatcher.new(My_App::Application)
  #
  def initialize(params={})
    @application         = params[:application]
    @application       ||= Aurita::Main::Application
    @decorator           = Aurita::Main::Default_Decorator.new
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
    params                = Aurita::Attributes.new(request)
    params[:_request]     = request
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

    begin
      raise ::Exception.new('No controller given') if(controller.nil? || controller == '') 

      model_klass      = @application.get_model_klass(controller)
      controller_klass = @application.get_controller_klass(controller)

      raise ::Exception.new('Unknown controller: ' << controller.inspect) unless controller_klass
      
      controller_instance = controller_klass.new(params, model_klass)

      response = false
      @logger.log("Calling model interface method #{controller}.#{action}")
      
      element  = controller_instance.call_unguarded(action)
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

      mode                 = response[:mode].to_sym if response && response[:mode]
      mode               ||= :default 
      response[:mode]      = mode
      params[:_controller] = controller_instance

      response_body = @decorator.render(model_klass, response, params)

      @num_dispatches += 1

    rescue Exception => excep
      @logger.log(excep.message)
      @logger.log(excep.backtrace.join("\n"))
      response_body = excep.message
    end

    return [ status, response_header, response_body ]
  end # def }}}

end # class

