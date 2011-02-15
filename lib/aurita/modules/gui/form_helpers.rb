
require('lore')
require('aurita/base/exceptions')
require('aurita-gui/form')

Aurita.import(:base, :logging_methods)
Aurita.import_module :gui, :custom_form_elements
Aurita.import_module :gui, :form_generator
Aurita.import_module :gui, :button

module Aurita
module GUI

  module Form_Helpers
    include Aurita::Logging_Methods

    @@form_generator = Aurita::GUI::Form_Generator

    # Expects Lore::Exceptions::Validation_Failure. 
    #
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
    def notify_invalid_params(validation_failure)
    # {{{
      script = 'Aurita.handle_form_error('
      error_details = []
      validation_failure.serialize.each_pair { |table, fields| 
        fields.each_pair { |attrib_name, reason|
          message = tl("#{table.sub('.','_')}_#{attrib_name}__#{reason}".to_sym)
          form_element_id = "#{table}.#{attrib_name}"
          error_details << "{ field: '#{form_element_id}', reason: '#{reason.to_s}', " +
                             "value: '#{param(attrib_name.to_sym)}', message: '#{message}}' }"
        }
      }
      script << error_details.join(',')
      script << ');'
      exec_error_js(script)
    end # }}}

    # Decorates GUI::Form instance with GUI::Async_Form_Decorator 
    # and shifts resulting element into HTML part of response. 
    # Optional parameters are passed to constructor of decorator. 
    # Example: 
    #
    #   form = add_form
    #   render_form(form, :decorator_param => :value)
    #
    def render_form(form, params={})
      element = GUI::Async_Form_Decorator.new(form, params)
    # Should be avoided if possible: 
    # @response[:html] << element
      element
    end

    # Like #render_form, but only returns decorated form, 
    # without attaching to controller's @response object. 
    # Short for 
    #
    #   GUI::Async_Form_Decorator.new(form, params)
    #
    def decorate_form(form, params={})
      GUI::Async_Form_Decorator.new(form, params)
    end

    # Set custom form generator klass. 
    #
    def use_form_generator(fg_klass)
      @@form_generator = fg_klass
    end

    # Helper method for form generator (default: Aurita::GUI::Form_Generator, 
    # set in Aurita::Main::Base_Controller). 
    #
    # Generates a form for this controller's  model klass, derived from 
    # controller name (Foo_Controller -> model Foo). 
    #
    # Parmeters are: 
    #
    # - :model
    #   The model klass to generate the form for, in case it 
    #   differs from the default one. 
    # - :action
    #   Controller action to invoke (e.g. :perform_update). 
    # - :instance 
    #   The model instance used to populate form fields. 
    #
    # Example: 
    #
    #   form = model_form(:instance => inst, :action => :move)
    #
    # Returns configured instance of Aurita::GUI::Form. 
    # You might want to adjust this instance after generation for your 
    # specific purposes. 
    #
    def model_form(params={})
    # {{{
      method     = params[:action]
      instance   = params[:instance]
      klass      = params[:model]
      klass    ||= @klass

      custom_elements = {}
      log { "Custom Form Elements: #{custom_form_elements.inspect}" }
      custom_form_elements.each_pair { |clause, value|
        clause_parts = clause.to_s.split('.')
        table  = clause_parts[0..1].join('.')
        attrib = clause_parts[2]
        custom_elements[table] = Hash.new unless custom_elements[table]
        custom_elements[table][attrib.to_sym] = value
      }
      view = @@form_generator.new(klass)
      view.labels = Lang[plugin_name]
      view.custom_elements = custom_elements
      form = view.form

      form.add(GUI::Hidden_Field.new(:name => :action, :value => method.to_s, :required => true)) if method
      form.add(GUI::Hidden_Field.new(:name => :controller, :value => klass.model_name.to_s, :required => true))

      form_values = {}
      default_form_values.each_pair { |attrib, value|
        form_values[attrib.to_s] = value
      }
      
      if instance then
        instance.attribute_values.each { |table, args| 
          args.each { |name, value|
            form_values["#{table}.#{name}"] = value
          }
        }
        klass.get_primary_keys.each { |table, keys|
          keys.each { |key|
            pkey_field_name = "#{table}.#{key}"
            form.add(GUI::Hidden_Field.new(:name     => pkey_field_name, 
                                           :value    => instance.attribute_values[table][key], 
                                           :required => true))
          }
        }
      end
      
      if(defined? form_groups) then
        form.fields = form_groups
      end
      if(defined? form_hints) then
        form.hints = form_hints
      end

      form.set_values(form_values)

      title_key  = (klass.table_name).gsub('.','--')+'--add'
      form.title = (Lang[plugin_name][title_key]) unless Lang[plugin_name][title_key] == title_key
      klassname  = @klass.to_s.gsub('Aurita::','').gsub('Main::','').gsub('Plugins::','').gsub('::','__').downcase
      form.name  = klassname + '_' << method.to_s + '_form'
      form.id    = klassname + '_' << method.to_s + '_form'

      log('Update form fields: ' << form.fields.inspect)
      log('Update form elements: ' << form.element_map.keys.inspect)
      return form
    end # def }}}

    # Returns a basic form with hidden fields 'controller' and 'action'. 
    # Usage: 
    #   
    #   form = custom_form(:controller => 'MyPlugin::My_Controller', :action => :perform_add)
    #   form = decorate_form(:buttons => { |btn_params|
    #                                      Text_Button.new(:label   => 'OK', 
    #                                                      :onclick => btn_params[:onclick]
    #                                    })
    #
    def custom_form(params={})
      form = GUI::Form.new(:id => params[:id], :name => params[:name])
      form.add(GUI::Hidden_Field.new(:name => :controller, :value => params[:controller]))
      form.add(GUI::Hidden_Field.new(:name => :action,     :value => params[:action]))
      form
    end

    # Returns plain form object for a model instance identified by 
    # controller request parameters. 
    # Almost the same as #update_form() but does not set any 
    # dispatcher attributes (like 'controller' and 'method'). 
    #
    # This is useful for non-CRUD operations: 
    #
    #    form = instance_form(:model => Article)
    #    form.add(Hidden_Field.new(:name => 'controller', :value => 'Article_Version'))
    #    form.add(Hidden_Field.new(:name => 'method',     :value => 'perform_add'))
    #
    #
    def instance_form(params={})
    # {{{
      klass = params[:model]
      klass ||= @klass
      params[:instance] = load_instance(klass) unless params[:instance]
      model_form(params)
    end # }}}

    # Returns a preconfigured form for adding a 
    # instance of the model klass associated to this controller. 
    # 
    # For working with form objects, see Aurita::GUI::Form. 
    #
    def add_form(klass=nil) 
    # {{{
      form = model_form(:model => klass, :action => :perform_add)
      return form
    end # def }}}

    # Returns a preconfigured form for updating a 
    # instance of the model klass associated to this controller. 
    # 
    # For working with form objects, see Aurita::GUI::Form. 
    #
    def update_form(klass=nil) 
    # {{{
      form = model_form(:model => klass, :action => :perform_update, :instance => load_instance(klass))
      return form
    end # def }}}

    # Returns a preconfigured form for deleting a 
    # instance of the model klass associated to this controller. 
    # 
    # For working with form objects, see Aurita::GUI::Form. 
    #
    def delete_form(klass=nil) 
    # {{{
      klass     = @klass if klass.nil?
      instance  = load_instance(klass)
      form = model_form(:model => klass, :action => :perform_delete, :instance => instance)
      form.readonly! 
      return form
    end # def }}}

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
    #   { User.is_admin => false }
    #
    def default_form_values
      Hash.new
    end

  end

end
end

