
module Aurita
module GUI

  module Link_Helpers

    # Examples: 
    #
    #  resource_url_for('http://google.com')
    #  --> 'http://google.com'
    #
    #  resource_url_for(user_entity) 
    #  --> 'User/5'
    #
    #  resource_url_for(:entity => user_entity, :action => 'list_info') 
    #  --> 'User/5/list_info'
    #
    #  resource_url_for(:action => 'index', :some_param => 'value') 
    #  (in case @controller is of type Foo)
    #  --> 'Foo/index/some_param=value'
    #
    #  resource_url_for(:controller => 'Article', :action => 'index', :some_param => 'value') 
    #  --> 'Article/index/some_param=value'
    #
    def resource_url_for(*args)
      options = args.at(0)
      case options
      when String
        url = options
      when Hash
        action     = options[:action]
        action   ||= 'show'
        controller = options[:controller]
        if options[:entity] then
          entity       = options[:entity]
          controller ||= entity.model_name
          options.update(entity.key)
        end
        controller ||= short_model_name if respond_to?(:short_model_name)
        action     ||= 'show'
        url = ''
        url << controller.to_s << '/' 
        url << action.to_s << '/'
        get_params = options.dup
        get_params.delete(:action)
        get_params.delete(:controller)
        get_params.delete(:entity)
        url << get_params.to_get_params if get_params.size > 0
      when Aurita::Model
        entity         = args.at(0)
        options        = args.at(1)
        options      ||= {}
        controller     = options[:controller]
        controller   ||= entity.model_name
        action         = options[:action]
        action       ||= 'show'
        url = ''
        url << controller.to_s << '/' 
        url << action.to_s << '/'
        url << entity.key.to_get_params
        get_params = options.dup
        get_params.delete(:action)
        get_params.delete(:controller)
        get_params.delete(:entity)
        url << '&' << get_params.to_get_params if get_params.size > 0
      else
        entity         = args.at(0)
        options        = args.at(1)
        options      ||= {}
        controller   ||= entity.model_name
        action         = options[:action]
        url = "#{controller}"
        url << "/#{action}/" if action
        get_params = options.dup
        get_params.delete(:action)
        url << get_params.to_get_params if get_params.size > 0
      end
      url
    end

    # Examples: 
    #
    #  url_for('http://google.com')
    #  --> 'http://google.com'
    #
    #  url_for(user_entity) 
    #  --> '/aurita/User/5'
    #
    #  url_for(:entity => user_entity, :action => 'list_info') 
    #  --> '/aurita/User/5/list_info'
    #
    #  url_for(:action => 'index', :some_param => 'value') 
    #  (in case @controller is of type Foo)
    #  --> '/aurita/Foo/index/some_param=value'
    #
    #  url_for(:controller => 'Article', :action => 'index', :some_param => 'value') 
    #  --> '/aurita/Article/index/some_param=value'
    #
    def url_for(*args)
      case args[0]
      when String
        return args[0]
      when :back
     #  url = controller.request.env['HTTP_REFERER'] if controller
        url ||= 'javascript: history.back();'
      else 
        return "/aurita/#{resource_url_for(*args)}"
      end
    end

    # Returns RESTful URL to a resource. 
    # Examples: 
    #
    #   article = Wiki::Article.load(:article_id => 123)
    #   rest_url_for(article)
    #   --> 'Wiki::Article/123'
    #
    #   rest_url_for(article, :action => :delete)
    #   --> 'Wiki::Article/123/delete'
    #
    #   rest_url_for(article, :action => :delete, :param => :value)
    #   --> 'Wiki::Article/123/delete/param=value'
    #
    def rest_url_for(*args)
      options = args.at(0)
      case options
      when Hash
        action     = options[:action]
        action   ||= 'show'
        controller = options[:controller]
        key        = ''
        if options[:entity] then
          entity       = options[:entity]
          controller ||= entity.model_name
          key          = entity.key
        end
        url = "#{controller}/#{key}" 
        url << "/#{action}" if action
        get_params = options.dup
        get_params.delete(:action)
        get_params.delete(:controller)
        get_params.delete(:entity)
        url << get_params.to_get_params if get_params.size > 0
      when Aurita::Model
        entity         = args.at(0)
        options        = args.at(1)
        options      ||= {}
        controller     = options[:controller]
        controller   ||= entity.model_name
        action         = options[:action]
        key            = entity.key.values.first
        url = "#{controller}/#{key}"
        url << "/#{action}" if action
        get_params = options.dup
        get_params.delete(:action)
        get_params.delete(:controller)
        get_params.delete(:entity)
        url << '/' << get_params.to_get_params if get_params.size > 0
      else
        entity         = args.at(0)
        options        = args.at(1)
        options      ||= {}
        controller   ||= entity.model_name
        action         = options[:action]
        url = "#{controller}"
        url << "/#{action}" if action
        get_params = options.dup
        get_params.delete(:action)
        url << '/' << get_params.to_get_params if get_params.size > 0
      end
      url
    end

    # Resolves parameter Hash from link args. 
    # Helper method for #link_to, #call_to etc. 
    # Example: 
    #
    #   parse_link_args(:add) 
    #   -->
    #   { :action => :add }
    #
    #   parse_link_args('Show entry', some_model_inst)
    #   -->
    #   { :action => :show, :controller => 'Some_Model_Controller', :some_model_id => 122 }
    #
    def parse_link_args(*args)
      label  = false
      entity = false
      action = false
      case args.at(0)
      when Aurita::Model then
        entity   = args.at(0)
        params   = args.at(1)
      when Symbol then
        action   = args.at(0)
        params   = args.at(1)
      when String then
        label    = args.at(0)
        params   = args.at(1)
      when Hash then
        params   = args.at(0)
      end

      # For link_to(:add, entity, params) 
      if params.is_a?(Aurita::Model) then
        params   = args.at(2)
        entity   = args.at(1)
      end

      params ||= {}
      params[:entity] = entity if entity
      params[:label]  = label  if label
      params[:action] = action if action

      return params
    end

    # Examples: 
    #
    #  link_to('http://google.com', :target => '_blank') { 'google' }
    #  or
    #  link_to('google', 'http://google.com', :target => '_blank') 
    #  --> '<a href="http://google.com" target="_blank">google</a>'
    #
    #  link_to(user_entity) { 'link to this user' }
    #  --> '<a href="/aurita/User/5">link to this user</a>'
    #
    #  In case User#label_string is defined: 
    #  link_to(user_entity) 
    #  --> '<a href="/aurita/User/5">John Doe</a>'
    #
    #  link_to(:entity => user_entity, :action => 'list_info') 
    #  --> '/aurita/User/5/list_info'
    #
    #  In case @controller is of type Foo: 
    #  link_to(:action => 'index', :some_param => 'value')  { 'List all Foos' }
    #  --> '<a href="/aurita/Foo/index/some_param=value">List all Foos</a>'
    #
    #  url_for(:controller => 'Article', :action => 'index', :some_param => 'value') 
    #  --> '/aurita/Article/index/some_param=value'
    #
    def link_to(*args, &block)

      params   = parse_link_args(*args)

      label    = yield if block_given?
      label  ||= params[:label]

      return js_link_to(params) unless label

      if params[:options] then
        html_options = params[:options].dup 
        params.delete(:options)
      end
      html_options ||= {}
      target ||= params[:element]

      params.delete(:element)
      params.delete(:label)

      unless html_options[:onclick] then
        target_part = ", element: '#{target}' " if target
        html_options[:onclick]  = "Aurita.load({ action: '#{resource_url_for(params)}' #{target_part}}); return false; "
      end
      html_options[:href] = "/aurita/#{resource_url_for(params)}" unless target
      HTML.a(html_options) { label }.string
    end

    def link_to_call(*args, &block)

      params   = parse_link_args(*args)

      label    = yield if block_given?
      label  ||= params[:label]

      return js_link_to_call(params) unless label

      if params[:options] then
        html_options = params[:options].dup 
        params.delete(:options)
      end
      html_options ||= {}

      params.delete(:element)
      params.delete(:label)

      unless html_options[:onclick] then
        html_options[:onclick]  = "Aurita.call({ action: '#{resource_url_for(params)}'}); return false; "
      end
      HTML.a(html_options) { label }.string
    end

    def js_link_to(params)
        target = params[:element]
        params.delete(:element)

        onclick  = "Aurita.load({ action: '#{resource_url_for(params)}'"
        onclick << " , element: '#{target}'" if target
        onclick << " })"
      return "#{onclick}; "
    end

    def js_link_to_call(params)
      return "Aurita.call({ action: '#{resource_url_for(params)}' });"
    end

  end

end
end

