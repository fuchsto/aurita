
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
        get_params.delete(:target)
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
        get_params.delete(:target)
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
        get_params.delete(:target)
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
    #   { 
    #     :label         => 'Show entry', 
    #     :action        => :show, 
    #     :controller    => 'Some_Model_Controller', 
    #     :some_model_id => 122 
    #   }
    #
    def parse_link_args(*args, &block)
      label  = false
      entity = false
      action = false
      url    = false
      label  = yield if block_given? 
      case args.at(0)
      when Aurita::Model then
        entity   = args.at(0)
        params   = args.at(1)
      when Symbol then
        action   = args.at(0)
        params   = args.at(1)
      when String then
        if label then
          # Label has been set via block already, 
          # so first String argument must be URL: 
          url = args.at(0)
        else
          # Label has not been set via block, so 
          # first argument might be label: 
          label  = args.at(0) 
          params = args.at(1)
          if params.is_a?(String) then
            # First and second argument are Strings. 
            # Assuming first to be label, second to 
            # be URL: 
            url    = args.at(1)
            params = args.at(2)
          end
        end
      when Hash then
        params   = args.at(0)
      end

      # For 
      #   link_to(:add, entity, :controller => 'Specific_Model_Name') 
      # or
      #   link_to('edit this entry', entity, :action => :update)
      #
      # Note that args[0] can either be Symbol or String, so this 
      # has already been interpreted above, do not change it here. 
      if params.is_a?(Aurita::Model) then
        params   = args.at(2)
        entity   = args.at(1)
      end

      params ||= {}
      params[:entity] = entity if entity
      params[:label]  = label  if label
      params[:action] = action if action
      params[:url]    = url    if url

      return params
    end

    # Examples: 
    #
    #   link_to('http://google.com', :target => '_blank') { 'google' }
    # or
    #   link_to('google', 'http://google.com', :target => '_blank') 
    #   --> '<a href="http://google.com" target="_blank">google</a>'
    #
    #   link_to(user_entity) { 'link to this user' }
    #   --> '<a href="/aurita/User/5">link to this user</a>'
    #
    #   link_to(:entity => user_entity, :action => 'list_info') 
    #   --> '/aurita/User/5/list_info'
    #
    # In case @controller is of type Foo: 
    #
    #   link_to(:action => 'index', :some_param => 'value')  { 'List all Foos' }
    #   --> '<a href="/aurita/Foo/index/some_param=value">List all Foos</a>'
    #
    # Naming controller explicitly: 
    #
    #   url_for(:controller => 'Article', :action => 'index', :some_param => 'value') 
    #   --> '/aurita/Article/index/some_param=value'
    #
    # Within same controller, rendering an <a> tag: 
    #  
    #   link_to(:action => :list) { 'show list' }
    # 
    # Within same controller, rendering an onclick tag attribute: 
    # 
    #   link_to(:show)
    # 
    # Link to foreign controller action, rendering an tag; 
    # 
    #   link_to(:controller => 'Some_Controller', :action => :add) { 'add some' }
    # 
    # Without a label, rendering Javascript code for Ajax call: 
    # 
    #   link_to(:action => :update) 
    #
    # When providing a target ('_self', '_blank' ...) always returns a plain old link: 
    #
    #   link_to(:controller => 'Invoice', :action => :print, :target => '_blank') { 'Print' }
    #   -->
    #   <a href="Invoice/print" target="_blank">Print</a>
    # 
    # Link to a specific entity. If no :action is set, it will be defaulted to :show: 
    # 
    #   link_to(entity) { 'show entry' }
    #   link_to(entity, :action => :delete) { 'delete this entry' }
    # 
    # Same as
    # 
    #   link_to(entity, :delete) { 'delete this entry' }
    # 
    # By providing a DOM element id as :element or :to parameter, an Ajax call is performed and result loaded into this element: 
    # 
    #   link_to(:action => :add, :target => :element_dom_id) { 'remote call' } 
    # 
    # Any parameter different from :controller, :action, :target, :element, :onload and :to is interpreted as request parameter: 
    # 
    #   link_to(:action => :show, :viewparam => :table) { 'show as table' }
    # 
    # With javascript function to be called on load. Automatically renders an Ajaxified tag: 
    # 
    #   link_to(:action => :show, :onload => js.Aurita.do_something) { 'with onload function' }  
    #
    def link_to(*args, &block)

      params = parse_link_args(*args, &block)
      label  = params[:label]

      return js_link_to(params) unless label

      if params[:options] then
        html_options = params[:options].dup 
        params.delete(:options)
      end
      html_options ||= {}
      target ||= params[:element]

      params.delete(:element)
      params.delete(:label)

      unless params[:target] || html_options[:onclick] then
        target_part = ", element: '#{target}' " if target
        html_options[:onclick]  = "Aurita.load({ action: '#{resource_url_for(params)}' #{target_part}}); return false; "
      end
      if !target then
        html_options[:href] = "/aurita/#{resource_url_for(params)}" 
        html_options[:target] = params[:target]
      end
      HTML.a(html_options) { label }.string
    end

    def link_to_call(*args, &block)

      params = parse_link_args(*args, &block)
      label  = params[:label]

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

