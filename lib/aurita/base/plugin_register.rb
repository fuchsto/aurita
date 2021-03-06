
require 'aurita'
Aurita.import_module :gui, :module
Aurita.import_module :procedure

module Aurita

  # Convenience class for naming hooks. 
  #
  # Usage: 
  #
  #  Hook.app_right_column.statistics_box.to_s
  #  --> 
  #  "app_right_column.statistics_box"
  #
  class Hook

    def initialize(path) # :nodoc:
      @path = path
    end

    def self.method_missing(meth_symbol) # :nodoc:
      return self.new([meth_symbol])
    end
    def method_missing(meth_symbol) # :nodoc:
      return Hook.new(@path << meth_symbol)
    end

    # Returns hook path to String. 
    def to_s
      @path.join('.')
    end
  end

  class Plugin_Call # :nodoc:
    attr_reader :plugin, :controller, :method, :params, :constraint, :response

    def initialize(params)
      @plugin     = params[:plugin]
      @controller = params[:controller]
      @method     = params[:method]
      @params     = params[:params]
      @constraint = params[:constraint]
      @response   = params[:response]
    end

    def exec
    end

  end

  class Plugin_Register

    @@register = {}
    @@permission_register = {}

    # It is somehow a notify_observers method. 
    # Plugin_Register.get is used indirectly via Plugin_Methods.plugin_get(hook) and 
    # returns all results of controller methods mapped to the given hook. 
    # 
    def self.get(hook, *args)
      Aurita.log { 'PLUGIN REGISTER GET: ' << hook.inspect }

      components         = []
      params             = {}
      calling_controller = false
      if args[0].is_a?(Hash) then
        params             = args[0]
      else 
        calling_controller = args[0]
        params             = args[1]
      end
      
      plugin_call = @@register[hook.to_s]
      return components unless plugin_call
      plugin_call.each { |component| 
        if !component.constraint || component.constraint.call(params) then
          # Call params consists of params passed to plugin_get (params) 
          # and those provided in the plugin manifest statically (component.params): 
          call_params = {}
          call_params.update(params) if params
          call_params.update(component.params) if component.params
          caller_params   = calling_controller.params if calling_controller && calling_controller.respond_to?(:params)
          caller_params ||= {}
#         caller_params[:calling_controller] = calling_controller
          if component.response then
            if component.response.is_a?(Proc) then
              result = component.response.call(caller_params.update(call_params))
            else
              result = component.response
            end
          elsif call_params.size > 0 then
            result = component.controller.new(caller_params).call_guarded(component.method, call_params) 
          else
            result = component.controller.new(caller_params).call_guarded(component.method)
          end
          if result then
            if result.is_a?(Hash) || result.is_a?(String) || result.is_a?(Aurita::GUI::Element) || result.is_a?(Aurita::Procedure) || result.respond_to?(:aurita_gui_element) then
              components << result
            elsif result.instance_of?(Array) then
              components += result
            else
              raise ::Exception.new('Components have to be an Array, Hash or Aurita::GUI::Element instance (Given: ' << result.class.to_s + ') ' << component.inspect )
            end
          end
        end
      }
      return components
    end

    # Like Plugin_Register.get, but for plugin calls that do not 
    # respond with a GUI element or anything else. 
    # This is mostly used in 'perform_' methods, for example: 
    #
    #  def perform_add
    #    plugin_call(Hook.main.user_group.before_add, :params => @params)
    #    instance = super()
    #    plugin_call(Hook.main.user_group.after_add, :user => instance)
    #  end
    #
    # Plugin_Register.call is used indirectly via Plugin_Methods.plugin_call(hook) and 
    #
    def self.call(hook, *args)
      Aurita.log { 'PLUGIN REGISTER CALL: ' << hook.inspect }

      plugin_call        = @@register[hook.to_s]
      params             = {}
      calling_controller = false
      if args[0].is_a?(Hash) then
        params             = args[0]
      else 
        calling_controller = args[0]
        params             = args[1]
      end
      return unless plugin_call
      plugin_call.each { |component| 
        if !component.constraint || component.constraint.call(params) then
          # Call params consists of params passed to plugin_get (params) 
          # and those provided in the plugin manifest statically (component.params): 
          call_params = {}
          call_params.update(params) if params
          call_params.update(component.params) if component.params
          caller_params   = calling_controller.params if calling_controller
          caller_params ||= {}
#         caller_params[:calling_controller] = calling_controller
          if call_params.size > 0 then
            result = component.controller.new(caller_params).__send__(component.method, call_params) 
          else
            result = component.controller.new(caller_params).__send__(component.method)
          end
        end
      }
    end

    def self.add(params)
      hook = params[:hook].to_s
      @@register[hook]  = Array.new unless @@register[hook]
      @@register[hook] << Plugin_Call.new(params)
    end

    def self.add_permission(manifest, permission)
      plugin = manifest.plugin_name
      @@permission_register[plugin] = Array.new unless @@permission_register[plugin]
      @@permission_register[plugin] << permission
    end

    def self.permissions
      @@permission_register
    end

    def self.inspect
      @@register.inspect
    end

  end

end

