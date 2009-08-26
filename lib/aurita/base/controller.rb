
require('aurita-gui')
require('aurita-gui/form')
require('aurita-gui/button')
require('aurita/base/controller_methods')
require('aurita/base/controller_methods')
Aurita.import(:base, :exception, :parameter_exception)
Aurita.import(:base, :log, :class_logger)
Aurita.import_module :gui, :erb_template
Aurita.import_module :gui, :custom_form_elements
Aurita.import_module :gui, :async_form_decorator
Aurita.import(:base, :plugin_register)


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

  attr_reader :response, :request, :session, :params

  private

  @guard_blocks    = Hash.new 
  @@logger         = Aurita::Log::Class_Logger.new(self)
  @@erb_template   = Aurita::GUI::ERB_Template

  protected

  def self.log(message, level=nil, &block)
    @@logger.log(message, level, &block)
  end
  def log(message=nil, level=nil, &block)
    @@logger.log(message, level, &block)
  end

  # Send a plugin hook signal that will not be answered with 
  # GUI components. An optinal parameter Hash can be passed. 
  #
  # Example: 
  #
  #   plugin_call(Hook.mail.after_send, [ :params => values ])
  #
  #
  def plugin_call(hook, call_params=nil)
    Aurita::Plugin_Register.call(hook, self, call_params)
  end
  # Send a plugin hook signal that will be answered with an 
  # array of GUI components. An optinal parameter Hash can be passed. 
  #
  # GUI components have to be derived from Aurita::GUI::Element. 
  #
  # Example: 
  #
  #   components = plugin_get(Hook.profile.left, [ :params => values ])
  #
  #
  def plugin_get(hook, call_params=nil)
    Aurita::Plugin_Register.get(hook, self, call_params)
  end


  # Triggered if invalid attribute values are passed to a model 
  # method like Model.create, Model.update etc.
  #
  # Used to notify users of e.g. invalid form values. 
  #
  # Extends @response object by field 'error' in asynchronous mode, 
  # like
  #
  #   { html:  "<b>Something went wrong</b>", 
  #     error: "Aurita.handle_form_error({ field_id: 'name', 
  #                                        reason: 'Name must not be empty'})
  #   }
  #
  # See Aurita::Main::Default_Decorator for additional info on 
  # asynchronous response handling. 
  #
  def notify_invalid_params(excep)
  # {{{
    script = 'Aurita.handle_form_error('
    error_details = []
    excep.serialize.each_pair { |table, fields| 
      fields.each_pair { |attrib_name, reason|
        form_element_id = "#{table.gsub('.','_')}_#{attrib_name}"
        error_details << "{ field_id: '#{form_element_id}', reason: '#{reason.to_s}' }"
      }
    }
    script << error_details.join(',')
    script << ');'
    exec_error_js(script)
  end # }}}

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
  def call_guarded(method, args=[])
  # {{{
    Aurita.log('Guarded call of ' << self.class.to_s + '.' << method.to_s)
    
    method = method.to_sym
    permission = true
    if self.class.guards_for(method) then
      self.class.guards_for(method).each { |g| 
        permission = permission && (g.call(self))
      }
    end
    result = nil
    if permission then
      begin
         raise ::Exception.new("No such method: #{self.class.to_s}.#{method}") unless (respond_to?(method) || self.class.respond_to?(method))
         Aurita.log('Guards passed')
         result = __send__(method, *args) 
         Aurita.log('Call finished')
      rescue Lore::Exceptions::Validation_Failure => ikp
        Aurita.log('Invalid_Klass_Parameter in call_guarded')
        ikp.log()
        notify_invalid_params(ikp)
      rescue ::Exception => excep
        Aurita.log('Exception: ' << excep.inspect)
        raise excep
      end
    else
      raise Aurita::Auth_Exception.new('No permission to call \'' << method.to_s + '\'')
    end

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
  #
  def self.guard_interface(*methods, &block)
  # {{{
    @guard_blocks = Hash.new unless @guard_blocks
    methods.each { |m|
      @guard_blocks[m] = Array.new unless (@guard_blocks[m].instance_of?(Array))
      @guard_blocks[m] << block
    }
  end # }}}

  # Set default values for request params in case 
  # they are missing. 
  #
  # Example: 
  #
  #   default_params(:page => 1, :per_page => 30)
  #
  def default_params(params={})
    params.each_pair { |k,v|
      @params[k] = v unless @params[k]
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
    result = self.new.call_guarded(meth, params) 
    return result
  end

  # Guess model klass for this controller by conroller name, 
  # set this controllers @klass variable and return model 
  # klass if successful. 
  # 
  def resolve_model_klass
    model_klass = model()
    @klass = model_klass if model_klass
    return @klass
  end

  # Return plain name of this controller, like 'Article' for 
  # Article_Controller. 
  #
  def controller_name
  # {{{
    parts  = self.class.to_s.split('::')
    if parts[-2] == 'Main'
      c_name = parts[-1] 
    else
      c_name = parts[-2..-1].join('::')
    end
    c_name.gsub('_Controller','')
  end # }}}

  # Guess model klass for this controller by conroller name, 
  # and return model klass if successful. 
  # 
  def model
  # {{{
    return @model_klass if @model_klass
    model_klass_name = self.class.to_s.gsub('_Controller','')
    model_klass_resolved = true
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

  # Example: 
  #
  #   Wiki::Article_Controller#model_name   --> 'Wiki::Article'
  #
  # See also #model_name
  def short_model_name
    short_name = model_name
    short_name.sub!('Aurita::','')
    short_name.sub!('Plugins::','')
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
    params   = Hash.new if params.nil?
    @request = params[:_request]
    @session = params[:_session]
    @params  = params
    @params.delete('controller')
    @params.delete('action')
    @response = {}
    @response[:decorator]    = nil # Set in Decorator itself
    @response[:html]         = ''
    @response[:script]       = ''
    @response[:error]        = ''
    @response[:http_header]  = nil
    @klass = model_klass
    @logger = Aurita::Log::Class_Logger.new(self.class.to_s)
    resolve_model_klass unless @klass
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
  def render_controller(controller, action, params={})
  # {{{
    @params ||= {}
    params   = @params.dup.update(params)
    delegate = controller.new(params)
    result   = delegate.__send__(action)
    response = delegate.response
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
  # A default value can be specified: 
  #
  #   sort_dir = param(:sort_dir, :asc)
  #
  # This is short for
  #   
  #   sort_dir = param(:sort_dir)
  #   sort_dir ||= :asc
  #
  def param(key=nil, default=nil)
  # {{{
    return @params[key] if (key && @params[key])
    return @params unless key
    return default if default
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
      @params[k] = v
    }
  end # }}}
  alias set_param set_params

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

  # Load instance for this controller. 
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
  def load_instance(klass=nil)
  # {{{
    klass ||= @klass 
    raise ::Exception.new('Unknown @klass for ' << self.class.to_s) unless klass
    if !@instance then
      load_args   = @params unless param(:id)
      load_args ||= id_hash()
      @instance = klass.load(load_args) 
    end
    if !@instance then
      puts tl(:content_does_not_exist)
      return
    end
    # raise ::Exception.new('Unable to load instance for ' << self.class.to_s + '. Params: ' << @params.inspect) unless @instance
    return @instance
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
    # @instance_id = id_values
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

  # Returns Hash of klasses derived from Lore::GUI::Custom_Element 
  # that will be used instead Lore's built-in element klasses. 
  # Example: 
  # 
  #   { User.profile_pic => Select_Picture_Element }
  #
  def custom_form_elements
    Hash.new
  end

  # Returns Hash of form values to be used in model_form 
  # in case no other value has been specified. Example: 
  # 
  #   { User.is_admin => 'f' }
  #
  def default_form_values
    Hash.new
  end

end # class

