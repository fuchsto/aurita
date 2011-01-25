
require('aurita-gui')
require('aurita-gui/form')
require('aurita-gui/button')
require('aurita/base/controller_methods')
Aurita.import_module :gui, :custom_form_elements
Aurita.import(:base, :exception, :parameter_exception)
Aurita.import(:base, :log, :class_logger)
Aurita.import_module :gui, :erb_template
Aurita.import_module :gui, :async_form_decorator
Aurita.import_module :gui, :form_helpers
Aurita.import_module :cache, :simple
Aurita.import(:base, :plugin_register)
Aurita.import(:base, :controller_response)
Aurita.import(:base, :plugin_methods)


# All controller classes are derived from Aurita::Base_Controller. 
# Base_Controller provides the most basic helpers needed to 
# implement a controller for Aurita. 
# See Aurita::Plugin_Controller for additional information on 
# implementing controllers for Aurita plug-ins. 
#
# Base_Controller also includes helper methods from 
# Aurita::Base_Controller_Methods. 
#
# A quick cheat sheet: 
#
# == Logging
#
#   log('the log message') 
#
# This will log on DEBUG level. Specify another one like this: 
#
#   log.info { 'I will be logged on log level INFO' }
#
# Or better: 
#
#   log.info { "complex operation returned: #{complex_operation()}" }
#
# When passing a block, its content will not be evaluated in case 
# the logger is disabled or ignoring this log level, which 
# increases performance in production mode. 
#
# Log messages will be written to path/to/log/aurita/run.log
#
# == Render strings
#
#    puts 'hello' 
#
#    render_string(:html => 'hello', 
#                  :script => "alert('world');")
#
#    p some_object
#
# == Views
#
# Views should be avoided in favor of GUI::Widget instances, 
# but sometimes a plain, old view is just fine. They are also 
# a bit faster since views are precompiled strings, of course. 
#
# Search path for views is: 
#
#   - project (the_project/views/the_view.rhtml)
#   - plugin, in case you are in a Plugin_Controller (the_plugin/views/the_view.rhtml)
#   - aurita (auria/main/views/the_view.rhtml)
#
# First hit will be used. 
#
# render (print) it: 
#
#   render_view(:the_view, :foo => 'wombat', :bar => 'giraffe')
#
# Render it to a string: 
#
#   string = view_string(:the_view, :foo => 'wombat', :bar => 'giraffe')
#
# == Calling foreign controllers
#
# Call method from another controller: 
#
#   render_controller(The_Controller, :the_method, :some_optional_params => 'value')
#
# == Plugin hooks
#
# Get GUI elements from plugins (emit a hook signal plugins may respond to): 
#
#   elements_from_plugins = plugin_get(Hook.your.hook.name, 
#                                      :some_optional_params => 'value')
#
# Call a plugin method (returns nothing, just calls listeners): 
#
#   plugin_call(Hook.your.hook.name, 
#               :some_optional_params => 'value')
#
# Plugin controller methods can now be registered as listeners to 
# Hook.your.hook.name
#
# == Request parameters
#
# Assuming request aurita/The_Plugin::Foo/the_method/foo=wombat&bar=giraffe
#
#   foo = param(:foo)     # --> 'wombat'
#   bar = param(:bar)     # --> 'giraffe'
#
#   set_param(:bar => 'elephant')
#   bar = param(:bar)     # --> 'elephant'
#
#   set_default_params(:page => 1, :per_page => 30)
#
#   page = param(:page)   # --> 1
#
# == Automated form building
#
# Assuming controller Foo_Controller: 
#
#    form = add_form  
#
# Returns form object preconfigured for adding an instance of model Foo
#
#    form = update_form  
#
# Returns form object preconfigured for updating current instance of model Foo. 
# Instance will be retreived by calling #load_instance. You can define the 
# model instance yourself: 
#
#    form = update_form(:instance => Foo.load(:foo_id => 23)
#
# Forms for deleting an instance works the same: 
#
#    form = delete_form(:instance => Foo.load(:foo_id => 23)
#
# You can define model, action and instance yourself by using #model_form: 
#
#    form = model_form(:model    => Bar, 
#                      :action   => :perform_delete_if_necessary, 
#                      :instance => Bar.load(:bar_id => 42)
#
# parameter :model will default to model class derived from controller class
# name. 
# 
class Aurita::Base_Controller 
  include Aurita::Base_Controller_Methods
  include Aurita::Plugin_Methods
  include Aurita::GUI::Form_Helpers

  attr_reader :response, :request, :session, :params

  private

  @guard_blocks    = Hash.new 
  @logger          = Aurita::Log::Class_Logger.new(self)
  @@erb_template   = Aurita::GUI::ERB_Template

  protected

  def self.log(message, level=nil, &block)
    return @logger unless (message || block_given?)
    @logger.log(message, level, &block)
  end
  def log(message=nil, level=nil, &block)
    return @logger unless (message || block_given?)
    @logger.log(message, level, &block)
  end


  public
  
  # To be used in Dispatcher#dispatch(cgi_request) only. 
  # Calls controller method after validating the user's permissions 
  # as defined by controller guards. 
  #
  # Every controller method is indirectly invoced using method 
  # call_guarded. 
  #
  # In case a method guard block returns false, an Aurita::Auth_Exception 
  # is raised. 
  # 
  # On guarding controller methods, see
  # - Base_Controller.guard_interface(:method_name) { when to allow method call }
  # - Base_Controller.guards_for(method)
  # 
  # Also renders invalid model parameters to GUI output. 
  # Also see Base_Controller.notify_invalid_params. 
  #
  def call_guarded(method, *args)
  # {{{
    log { "Guarded call of #{self.class.to_s}.#{method.to_s}" }

    if method.empty? || !(respond_to?(method.to_sym) || self.class.respond_to?(method.to_sym)) then
      raise ::Exception.new("No such method: #{self.class.to_s}.#{method}") 
    end

    args       = args.flatten
    method     = method.to_sym
    permission = true
    result     = nil

    if self.class.guards_for(method) then
      self.class.guards_for(method).each { |g| 
        permission = permission && (g.call(self))
      }
    end
    
    if !permission then
      raise Aurita::Auth_Exception.new('No permission to call \'' << method.to_s + '\'')
    end
    
    begin

      # TODO: Polish cache handling and after-hooks
      
      Aurita::Plugin_Register.call(Hook.__send__(self.class.to_s.downcase.gsub('::','__')).__send__("before_#{method}"), self)
      
      controller_cache = self.class.cache
      cached_actions   = self.class.cached_actions
      
      if cached_actions.include?(method.to_sym) then
        cache_params = @params.to_hash.update(:action => method)
        
        log('Using controller cache ' << controller_cache.inspect) 
        cached = controller_cache.get(cache_params)
        if cached then
          log('Controller cache hit') 
          result    = cached[:result]
          @response = cached[:response] 
          return result
        else 
          log('Controller cache miss') 
          result    = __send__(method, *args)
          
          after_hooks = self.class.hooks_after(method)
          if after_hooks then 
            log("Calling hook after method #{method}")
            after_hooks.each { |hook| hook.call(self) }
          end

          controller_cache.store(cache_params) { { :response => @response, 
                                                   :result   => result } } 
        end
      else
        log('No controller cache defined')
        result = __send__(method, *args)
        
        after_hooks = self.class.hooks_after(method)
        if after_hooks then 
          log("Calling hook after method #{method}")
          after_hooks.each { |hook| hook.call(self) }
        end

      end
      
      @response = Controller_Response.unify(result, @response)
      
      Aurita::Plugin_Register.call(Hook.__send__(self.class.to_s.downcase.gsub('::','__')).__send__("after_#{method}"), self)

      log("Call finished (#{method}), query count is #{Lore::Connection.query_count}")
    rescue Lore::Exceptions::Validation_Failure => ikp
      log('Validation failure in call_guarded')
      ikp.log()
      notify_invalid_params(ikp)
    rescue ::Exception => excep
      log('Exception: ' << excep.message)
      excep.backtrace.each { |l|
        log(l)
      }
      raise excep
    end

    return result
  end # }}}
  
  # Unguarded, uncached controller call. 
  # This call method is for pollers, like autocompletion, and does not check 
  # the user's permissions to call a method. 
  # It also skips caching mechanisms and model validations. 
  #
  # #call_unguarded is used by Aurita::Dispatcher instances with @poller flag 
  # set. 
  # See Aurita::Handler::Aurita_Poller_Application for details. 
  #
  def call_unguarded(method, *args)
  # {{{
    log { "Unguarded call of #{self.class.to_s}.#{method.to_s}" }

    args      = args.flatten
    result    = __send__(method.to_sym, *args) 
    @response = Controller_Response.unify(result, @response)

    return result
  end # }}}

  public

  # Returns guard blocks for a specific controller method. 
  # Should only be needed from within Dispatcher.dispatch(). 
  def self.guards_for(method)
    @guard_blocks = Hash.new unless @guard_blocks
    @guard_blocks[method]
  end

  protected

  # Guard interfaces with conditions. 
  # Block has to return true for the controller method to be 
  # called. 
  #
  # Example: 
  #
  #   class Account_Controller < Aurita::Base_Controller
  #     guard_interface(:delete, :perform_delete) { 
  #       Aurita.user.may(:delete_accounts)
  #     }
  #     ...
  #   end
  #
  # Aliases for guard_interface are guard_interfaces() and guard(). 
  #
  # For guarding default CRUD methods (show, list, add, perform_add, 
  # update, perform_update, delete, perform_delete), use: 
  #
  #   guard_interface(:CRUD)
  #
  # Or to just guard add, delete and update methods, but allow show 
  # and list:
  #
  #   guard_interface(:CUD)
  #
  # This also works along with other methods, like: 
  #
  #   guard(:CRUD, :reorder, :publish)
  #
  def self.guard_interface(*methods, &block)
  # {{{
    @guard_blocks = Hash.new unless @guard_blocks
    methods.each { |m|
      if m == :CRUD then
        guard_interface(:show, :list, :add, :perform_add, :update, 
                        :perform_update, :delete, :perform_delete, &block)
      elsif m == :CUD then
        guard_interface(:add, :perform_add, :update, 
                        :perform_update, :delete, :perform_delete, &block)
      else
        @guard_blocks[m] = Array.new unless @guard_blocks[m].is_a?(Array)
        @guard_blocks[m] << block
      end
    }
  end # }}}

  class <<self
    alias guard guard_interface
    alias guard_interfaces guard_interface
  end

  # Define hooks to call after given methods. 
  # Example: 
  #
  #    after(:perform_add, :perform_delete, :perform_update) { |controller_instance|
  #       invalidate_cache(:list)
  #    }
  #
  def self.after(*methods, &block)
    @hooks_after = Hash.new unless @hooks_after
    methods.each { |m|
      @hooks_after[m] = Array.new unless @hooks_after[m].is_a?(Array)
      @hooks_after[m] << block
    }
  end

  def self.clear_after(*methods)
    return unless @hooks_after
    methods.each { |m|
      @hooks_after.delete(m)
    }
  end

  # Returns Hash of all hooks defined via Controller.after()
  # by method name. 
  def self.hooks_after(method)
    @hooks_after[method] if @hooks_after
  end

  # Returns this controller's cache implementation class, if any. 
  def self.cache
    (@cache || false)
  end

  # Enabe caching for this controller by optionally providing a 
  # cache implementation class (Default is Aurita::Cache::Simple). 
  # Example: 
  #
  #   use_cache(Cache::Memcached)
  # 
  # Automatically adds this controller's base model as cache 
  # dependency, so caches of Article_Controller depend on 
  # model Article. 
  #
  # See Cache::Simple for details on caching. 
  #
  def self.use_cache(cache_class=nil)
    cache_class ||= Cache::Simple
    @cache = cache_class.new(self)
    klass  = resolve_model_klass()
    @cache.depends_on(klass) if klass
  end

  # Add a model this controller's cache depends on. 
  # Same as 
  #
  #   Controller.cache.depends_on(*models)
  #
  # See Cache::Simple for details on caching. 
  def self.cache_depends_on(*models)
    @cache ||= Cache::Simple.new(self)
    @cache.depends_on(*models)
  end

  # Get response from cache by providing 
  # request parameters. 
  # Same as 
  #
  #   Controller.cache.get(params)
  #
  # It is automatically called in Controller.call_guarded, 
  # usually you shouldn't need to use this method manually. 
  #
  # See Cache::Simple for details on caching. 
  def self.get_cached(params={})
    return false unless @cache
    @cache.get(params)
  end

  # Clear this controller's cache, either completely 
  # or just for a given actions. 
  # May also be used outside of this controller. 
  # Same as 
  #
  #   Controller.cache.invalidate([actions])
  #
  # Example: 
  #
  #   class Event_Controller < Plugin_Controller
  #
  #     def perform_add
  #       # ...
  #       Calendar_Controller.invalidate_cache(:day, :week, :month)
  #     end
  #
  #   end
  #
  # Note that usually this would be solved by 
  # adding model Event to Calendar_Controller's 
  # cache dependencies: 
  #
  #   class Calendar_Controller
  #     cache_depends_on Event
  #
  #     ...
  #   end
  #
  # See Cache::Simple for details on caching. 
  def self.invalidate_cache(*actions)
    @cache.invalidate(actions)
  end
  def invalidate_cache(*actions)
    self.class.invalidate_cache(*actions)
  end

  # Define which actions to cache. 
  # Example: 
  #
  #   class Calendar_Controller < Plugin_Controller
  #     cache_actions :day, :month, :list, :add, :update
  #     
  #     ...
  #   end
  #
  def self.cache_actions(*actions)
    @cached_actions = actions
  end
  def self.cached_actions
    @cached_actions || []
  end

  # Set default values for request params in case 
  # they are missing. 
  #
  # Example: 
  #
  #   default_params(:page => 1, :per_page => 30)
  #
  def default_params(params={})
    params.each_pair { |k,v|
      @params[k.to_sym] = v unless @params[k.to_sym]
    }
  end
  
  # Redirects class method calls to a new instance of this 
  # controller klass. 
  # Note that this new instance operates on an own @response
  # object! This is useful for calling controller methods 
  # that implement a procedure without any output. 
  #
  # Example: 
  #
  #   def show
  #     # Will not render to this controllers output
  #     Other_Controller.perform_something(:some, :params) 
  #   end
  #
  def self.method_missing(meth, *params)
    result = self.new.call_guarded(meth, *params) 
    return result
  end

  # Explicitly set Aurita::Model class this controller is 
  # using. 
  def self.use_model(model_klass)
    @klass = model_klass
  end

  # Guess model klass for this controller by conroller name, 
  # set this controllers @klass variable and return model 
  # klass if successful. 
  # 
  def self.resolve_model_klass
    model_klass = model()
    @klass = model_klass if model_klass
    return @klass
  end
  def resolve_model_klass
    self.class.resolve_model_klass
  end

  # Example: 
  #
  #   resolve_conroller_klass('Wiki::Article') 
  #   --> Aurita::Plugins::Wiki::Article_Controller
  #
  def resolve_controller_klass(controller_name)
    begin
      @application.get_controller_klass(controller_name) 
    rescue ::Exception => e
      raise ::Exception.new("Could not resolve controller class for #{controller_name}. #{@params[:_application].inspect}")
    end
  end

  # Return plain name of this controller, like 'Article' for 
  # Article_Controller. 
  #
  def self.controller_name
  # {{{
    c_name = self.to_s

    c_name.sub!('Aurita::','')
    c_name.sub!('Main::','')
    if !c_name.sub!('Plugins::','') then
      c_name = c_name.split('::').last
    end
    c_name
  end # }}}
  def controller_name
    self.class.controller_name
  end

  # Guess model klass for this controller by conroller name, 
  # and return model klass if successful. 
  # 
  def self.model
  # {{{
    return @klass if @klass
    model_klass_name = self.to_s.gsub('_Controller','')
    begin
      model_klass = eval(model_klass_name)
    rescue ::Exception => excep
      # Model klass does not exist or is not loaded
      return false
    end
    return model_klass
  end # }}}

  # Example: 
  #
  #   Wiki::Article_Controller#model_name   --> 'Aurita::Plugins::Wiki::Article'
  #
  # See also #short_model_name
  def model_name 
    self.class.to_s.gsub('_Controller','')
  end
  def self.model_name
    self.to_s.gsub('_Controller','')
  end

  # Example: 
  #
  #   Wiki::Article_Controller#model_name   --> 'Wiki::Article'
  #
  # See also #model_name
  def short_model_name
    short_name = model_name
    short_name.sub!('Aurita::','')
    short_name.sub!('Main::','')
    if !short_name.sub!('Plugins::','') then
      short_name = short_name.split('::').last
    end
    short_name
  end
  def self.short_model_name
    short_name = model_name
    short_name.sub!('Aurita::','')
    if !short_name.sub!('Plugins::','') then
      short_name = short_name.split('::').last
    end
    short_name.sub!('Main::','')
    short_name
  end

  # You will most probably never instantiate a controller 
  # youself, as this is wrapped by a number of helpers. 
  # In case you want to delegate a call to a foreign controller, 
  # use #render_controller. 
  #
  def initialize(params={}, model_klass=false)
  # {{{
    params       = Hash.new if params.nil?
    @request     = params[:_request]
    @session     = params[:_session]
    @application = params[:_application]
    @params      = params
    @params.delete('controller')
    @params.delete(:_application)
    @action      = @params['action']
    @params.delete('action')
    @response = {}
    @response[:decorator]    = nil # Set in Decorator itself
    @response[:html]         = ''
    @response[:script]       = ''
    @response[:error]        = ''
    @response[:http_header]  = nil
    @klass   = model_klass
    @klass ||= resolve_model_klass 
    @logger  = Aurita::Log::Class_Logger.new(self.class.to_s)
  end # }}}

  # Call action from a foreign controller. This is useful for 
  # including partials from another controller. If possible and 
  # sensible in a specific situation, this should be avoided 
  # in favor of plugin calls. 
  #
  # Automatically passes current @params, which can be 
  # extended / overridden with third argument. 
  #
  # In this example, method Some_Foreign_Controller.list is 
  # called with fake request parameter 'user_id': 
  #   
  #   render_controller(Some_Foreign_Controller, :list, :user_id => 123)
  #
  def render_controller(controller, action=:show, params={})
  # {{{
    if controller.is_a?(String) then
      iface      = controller.split('/')
      controller = resolve_controller_klass(iface[0])
      action   ||= iface[1].to_sym if iface[1]
      cparams    = iface[2].split('&') if iface[2]
      cparams  ||= []
      cparams.each { |kv|
        kv = kv.split('=')
        params[kv[0].to_sym] = kv[1].to_s
      }
    end
    @params  ||= {}
    params     = @params.dup.update(params)
    params[:_application] = @application
    delegate   = controller.new(params)
    result     = delegate.__send__(action)
    response   = delegate.response
    response ||= {}
    @response[:html]   << response[:html]
    @response[:script] << response[:script]
    @response[:error]  << response[:error]
    return result
  end # }}}
  
  # Print a string. 
  # More precisely: Appends string to HTML part of response 
  # object. 
  def puts(string)
    @response[:html] = '' unless @response[:html]
    @response[:html] << string.to_s
  end

  # Print dump of an object using puts. 
  def p(obj)
    puts obj.inspect
  end

  # Render a view to string. 
  # Example 
  #
  #    string = view_string(:the_view, :some => 'params')
  #
  def view_string(template, params={})
    params[:_controller] = self
    template = template.to_s + '.rhtml' if template.instance_of? Symbol
    @@erb_template.new(template.to_s, params).string
  end

  # Print a view. 
  # Example 
  #
  #    render_view(:the_view, :some => 'params')
  #
  # Also accepts parameter :script, containing javascript 
  # code to be executed on load. 
  #
  def render_view(template, params={})
  # {{{
    params[:_controller] = self
    template = (template.to_s << '.rhtml') if template.instance_of? Symbol
    content = @@erb_template.new(template, params).string
    @response[:html] << content
    @response[:script] << params[:script].gsub("\n",' ') if params[:script]
  end # }}}

  # Print a string. 
  # Also accepts parameter :script, containing javascript 
  # code to be executed on load. 
  # More convenient for this is #puts, of course. 
  def render_string(params={})
  # {{{
    @response[:html] = '' unless @response[:html]
    @response[:html]   << params[:html].to_s
    @response[:script] << params[:script].gsub("\n",' ') if params[:script]
  end # }}}

  # Tells client to execute given javascript code on 
  # load of response content. Useful for init code, 
  # redirects etc. 
  # Example: 
  #
  #   render_view(:the_view, :some => 'params')
  #   exec_js("alert('response has been rendered');")
  #
  # Code passed to exec_js will always be executed on 
  # load, so this is equivalent to 
  #
  #   exec_js("alert('response has been rendered');")
  #   render_view(:the_view, :some => 'params')
  #
  # Order of exec_js calls will be preserved, though: 
  #
  #   exec_js("alert('first message');")
  #   render_view(:the_view, :some => 'params')
  #   exec_js("alert('second message');")
  #
  # --> 
  #  
  #   alert('first message'); alert('second message'); 
  #
  def exec_js(js_code)
    @response[:script] << js_code.to_s.gsub("\n",' ').gsub('"','\"')
  end
  
  # Like #exec_js, but renders Javascript code to 'error' part of 
  # this controller's @response object. 
  def exec_error_js(js_code)
    @response[:error] << js_code.to_s.gsub("\n",' ').gsub('"','\"')
  end

  # Renders plain text as HTML into HTML part of response. 
  def render_text(text)
    text.to_html!
    @response[:html] << text
  end

  def render_file(path)
    File.open(path) { |file|
      file.each { |line| 
        puts line
      }
    }
  end

  def render(element, params={})
    @response[:html]   = '' unless @response[:html]
    @response[:script] = '' unless @response[:script]

    if element.respond_to?(:string) && element.respond_to?(:script) then
      @response[:html]   << element.string
      @response[:script] << element.script
    elsif element.is_a?(Array)
      element.each { |e| render(e) }
    elsif element.is_a?(File) then
      render_file(file)
    elsif element.is_a?(String)
      @response[:html]   << element
    elsif element.is_a?(Symbol)
      render_view(element, params)
    else
      puts element.to_s
    end
  end

  # Define which content decorator to use. 
  #
  # Decorators are like regular templates that wrap around 
  # controller output. 
  #
  # For details, see Aurita::Main::Default_Decorator. 
  #
  def use_decorator(decorator_name)
    @response[:decorator] = decorator_name
  end

  public 

  # Return request parameter value by its name. 
  # Example: 
  #
  #   GET/POST params: foo: 23, bar: 'the value'
  #
  #   param(:foo) --> 23
  #   param(:bar) --> 'the value'
  #
  # A default value can be specified that will be returned 
  # if the requested request parameter is missing: 
  #
  #   sort_dir = param(:sort_dir, 'asc')
  #
  # This is short for
  #   
  #   sort_dir = param(:sort_dir)
  #   sort_dir ||= :asc
  #
  def param(key=nil, default=nil)
  # {{{
    return @params[key] if (key && @params[key].to_s != '')
    return @params unless key
    return default if default
    return nil
  end # }}}

  protected

  # Set / overwrite request parameter values. 
  # Example: 
  #
  #   set_params(:page => 1, :per_page => 30)
  #
  def set_params(param_hash={})
  # {{{
    param_hash.each_pair { |k,v|
      @params[k.to_sym] = v
    }
  end # }}}
  alias set_param set_params

  def delete_params(*params)
    params.each { |k| @params[k.to_sym] = nil }
  end
  alias delete_param delete_params

  # Helper for prevariants. Raises an exception 
  # if one of the given parameters is not set. 
  #
  # Example: 
  #
  #   def move
  #     expect(:old_pos, :new_pos)
  #     ...
  #   end
  #
  def expect(*params)
  # {{{
    missing = []
    params.each { |p|
      missing << p unless param(p)
    }
    raise ::Exception.new("Missing arguments: #{missing.join(', ')}") if missing.length > 0
  end # }}}
  alias expects expect

public

  # Load model instance identified by primary key attribute 
  # values in request parameters (@params). 
  # Model class to load an instance from is derived from 
  # controller name. Also caches this instance for this 
  # request. 
  # Expects primary key to be set in params. 
  # Example: 
  #
  #   class Foo_Bar_Controller
  #     def example
  #       inst  = load_instance()  # --> Foo_Bar.load(:foo_bar_id => param(:foo_bar_id))
  #       other = load_instance()  # --> returns cached @instance
  #     end
  #   end
  #
  #
  # Example: 
  # Request is
  #
  #   [controller] Wiki::Article
  #   [article_id] 123
  #
  # If there is only one primary key defined in the model klass, 
  # attribute 'id' can be used in request, too. This is needed 
  # for REST protocol: 
  #
  #   [controller] Wiki::Article
  #   [id] 123
  #
  # load_instance would look up instance like: 
  #
  #   Wiki::Article.get(123)
  #
  # This is very useful, as this method also works for 
  # polymorphic controller methods. It is thus recommended to 
  # use load_instance instead of loading model instances 
  # manually. 
  # 
  # Example: 
  #
  #   class Article_Controller < Aurita::Plugin_Controller
  #     def perform_commit_version
  #       article = load_instance
  #       # Modify aricle
  #     end
  #   end
  #  
  #   class Memo_Article_Controller < Article_Controller
  #     # no need to overload perform_commit_version as 
  #     # it automatically operates on model Memo_Article
  #   end
  #   
  #
  def load_instance(klass=nil)
  # {{{
    klass ||= @klass 
    raise ::Exception.new('Unknown @klass for ' << self.class.to_s) unless klass
    if !@instance then
      if param(:id) then
        @instance = klass.get(param(:id))
      else
        load_args   = @params 
        load_args ||= id_hash()
        @instance = klass.load(load_args) 
      end
    end
    if !@instance then
      return false
    end
    return @instance
    # raise ::Exception.new('Unable to load instance for ' << self.class.to_s + '. Params: ' << @params.inspect) unless @instance
  end # }}}

  # Returns primary key value passed in reqeust parameters. 
  # Name of primary key is retreived from model klass 
  # associated with this controller (Foo_Controller -> model Foo). 
  # In case you want to retreive the primary key value 
  # of another model klass, pass it as an argument. 
  #
  # If more than one primary key value could be resolved, 
  # all values are returned as an array. 
  def id(klass=nil)
  # {{{
    return param(:id) if param(:id)
    if !@instance_id then
      klass ||= @klass 
      return unless klass
      id_values = []
      klass.get_own_primary_keys.each { |key|
        id_values << param(key.to_sym) if param(key.to_sym) 
      }
      @instance_id = id_values.first 
    end
    return @instance_id 
  end # }}}

  # Returns primary key value passed in reqeust parameters as 
  # key / value hash. 
  # Name of primary key is retreived from model klass 
  # associated with this controller (Foo_Controller -> model Foo). 
  # In case you want to retreive the primary key value 
  # of another model klass, pass it as an argument. 
  def id_hash(klass=nil)
  # {{{
    if !@instance_id_hash then
      klass ||= @klass 
      if param(:id) then
        @instance_id_hash = { klass.get_own_primary_keys.first.to_sym => param(:id) }
      else
        klass ||= @klass 
        id_values = {}
        klass.get_own_primary_keys.each { |keys|
          keys.each { |key|
            id_values[key.to_sym] = param(key.to_sym) if param(key.to_sym) 
          }
        }
        @instance_id_hash = id_values
      end
    end
    return @instance_id_hash
  end # }}}

  def self.set_default_redirects
    after(:perform_add, :perform_update, :perform_delete) { |c|
      c.redirect_to(:action => :list)
    }
  end

end # class

