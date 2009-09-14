
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
      if block_given? then
        label  = yield()
        params = args.at(0)
        if params.kind_of? Aurita::Model then
          entity   = params
          params   = args.at(1)
          params ||= {}
          option_hash = args.at(2)
        end
      else
        label  = args.at(0)
        params = args.at(1)
        if label.kind_of? Aurita::Model then
          entity = label
          params = args.at(1)
          params ||= {}
          label  = entity.label_string
          option_hash = args.at(2)
        elsif params.kind_of? Aurita::Model then
          entity = params
          params = args.at(2)
          option_hash = args.at(3)
        end
      end
      params           ||= {}
      option_hash      ||= {}
      params[:entity]    = entity 
      if params[:options] then
        html_options = params[:options].dup 
        params.delete(:options)
      end
      html_options ||= {}
      target   = params[:target]
      target ||= params[:element]
      params.delete(:target)
      params.delete(:element)
      unless html_options[:onclick] then
        target_part = ", element: '#{target}' " if target
        html_options[:onclick]  = "Aurita.load({ action: '#{resource_url_for(params)}' #{target_part}}); return false; "
      end
      html_options[:href] = '#' << resource_url_for(params) unless target
      HTML.a(html_options) { label }.string
    end

    # Behaves like #link_to, but generates tag fields only, not a whole <a> tag. 
    #
    # Examples: 
    #
    #   <li class="user_entry" <%= onclick_link_to(user) %> ><%= user.username %></li>
    #   -->
    #   <li class="user_entry" onclick="Aurita.load({ action: 'User/5' });" >JohnDoe</li>
    #
    #   <li class="user_entry" <%= onclick_link_to(user, :target => 'dom_id') %> ><%= user.username %></li>
    #   -->
    #   <li class="user_entry" onclick="Aurita.load({ action: 'User/5', element: 'dom_id' });" >JohnDoe</li>
    #
    def onclick_link_to(*args)
      params = args.at(0)
      entity = nil
      if params.kind_of? Aurita::Model then
        entity = params
        params = args.at(1)
        params ||= {}
      else
        params = args.at(0)
      end
      params ||= {}
      params[:entity]  = entity 
      html_options = {}
      unless params[:onclick] then
        target = params[:target]
        params.delete(:target)
        params[:onclick]  = "Aurita.load({ action: '#{resource_url_for(params)}'"
        params[:onclick] << " , element: '#{target}'" if target
        params[:onclick] << " })"
      end
      return ' onclick="' << params[:onclick] + '; return false;" '
    end

  end

end
end

