
module Aurita
module GUI

  module Context_Menu_Helpers

    # Builds HTML tag options (in any surrounding, opening HTML tag) that 
    # enables a context menu for the tag it is called in. 
    # This element will be assigned a DOM id automatically. 
    # This id can be overridden using parameter :id. 
    # A DOM element id can be passed that will be highlighted when opening the menu. 
    # If not set, the wrapper element's id will be used. 
    # 
    # Usage: 
    #   
    #   # With article being a model instance: 
    #   <div <%= gui.context_menu(article, :params => { :key => 'value' } ) %> >
    #     <b>I have a context menu</b>
    #   </div>
    #   --> <div id="wiki__article__123" onmouseover="context_menu(...); " ...>
    #
    # Same as passing controller explicitly: 
    #
    #   <div <%= gui.context_menu(:model => 'Wiki::Article', :params => { :article_id => 123 ) %> >
    #     <b>Right-click here for a context menu. </b>
    #   </div>
    #   --> <div id="wiki__article__123" onmouseover="context_menu(...); " ...>
    #
    # Or passing a model entity as parameter: 
    #
    #   <div <%= gui.context_menu(:entity => article, :params => { :article_id => 123 ) %> >
    #     <b>Right-click here for a context menu. </b>
    #   </div>
    #
    # Set wrapper's DOM id and element to highlight: 
    #
    #   <div <%= gui.context_menu(article, :id => 'article_menu_element', :highlight_id => 'highlight_element') %> >
    #     <b>Right-click here for a context menu. </b>
    #   </div>
    #   --> <div id="article_menu_element" onmouseover="context_menu(...); " ...>
    #   
    def context_menu(*args)

      if args.at(0).kind_of? Aurita::Model then
        entity = args.at(0)
        params = args.at(1)
      else 
        params = args.at(0)
        entity = params[:entity]
      end
      params ||= {}
      additional_params = params[:params] 
      additional_params ||= {} 
      highlight_element_id = params[:highlight_id]
      result = ""
      if !params[:id] then
        params[:id] = entity.model_name.gsub('::','__').downcase + '_' << entity.key.values.join('_')
      end
      highlight_element_id ||= params[:id] 
      result << " id=\"#{params[:id]}\" "

      menu_params = entity.url_key
      additional_params.each_pair { |k,v|
        menu_params << "&#{k.to_s}=#{v.to_s}"
      }
      type   = params[:type]
      type ||= entity.model_name
      result << " onMouseOut=\"Aurita.context_menu_out(this); \" "
      result << " onMouseOver=\"Aurita.context_menu_over('#{type}', '#{menu_params}', '#{highlight_element_id}');\" "
    end

    # Builds a wrapping div-element (or any other HTML tag) that displays a context 
    # menu on right-click. This element will be assigned a DOM id automatically. 
    # This id can be overridden using parameter :id. 
    # A DOM element id can be passed that will be highlighted when opening the menu. 
    # If not set, the wrapper element's id will be used. 
    # 
    # Usage: 
    #   
    #   # With article being a model instance: 
    #   <% gui.begin_context_menu_for(article, :class => 'article_element') %>
    #     <b>Right-click here for a context menu. </b>
    #   <% gui.end_context_menu %>
    #   --> <div id="wiki__article__123" onmouseover="context_menu(...); " ...>
    #
    # Or: 
    #
    #   <% gui.begin_context_menu_for(:model => 'Wiki::Article', :params => { :article_id => 123 ) %>
    #     <b>Right-click here for a context menu. </b>
    #   <% gui.end_context_menu %>
    #   --> <div id="wiki__article__123" onmouseover="context_menu(...); " ...>
    #
    # Set wrapper's DOM id and element to highlight: 
    #
    #   <% gui.begin_context_menu_for(article, :id => 'article_menu_element', :highlight_id => 'highlight_element') %>
    #     <b>Right-click here for a context menu. </b>
    #   <% gui.end_context_menu %>
    #   --> <div id="article_menu_element" onmouseover="context_menu(...); " ...>
    #   
    def begin_context_menu_for(*args, &block)
      if args.at(0).kind_of? Aurita::Model then
        entity = args.at(0)
        params = args.at(1)
      else 
        params = args.at(0)
        entity = params[:entity]
      end
      additional_params = params[:params] 
      additional_params = {} unless additional_params
      highlight_element_id = params[:highlight_id]
      result = ""
      if !params[:id] then
        params[:id] = entity.model_name.gsub('::','__').downcase + '_' << entity.key.values.join('_')
      end
      highlight_element_id = params[:id] unless highlight_element_id

      menu_params = entity.url_key
      additional_params.each_pair { |k,v|
        menu_params << "#{k.to_s}=#{v.to_s}&"
      }
      params[:onmouseover] = '' unless params[:onmouseover]
      params[:onmouseout]  = '' unless params[:onmouseout]
      params[:onmouseover] << "Aurita.context_menu_over('#{entity.model_name}', '#{menu_params}', '#{highlight_element_id}'); "
      params[:onmouseout]  << "Aurita.context_menu_out(this); "
      params.delete(:entity)
      params.delete(:params)
      params[:close_tag] = false
      puts HTML.div(params, &block)
    end

    def self.end_context_menu(tag=:div)
      puts '</' << tag.to_s + '>'
    end

  end

end
end

