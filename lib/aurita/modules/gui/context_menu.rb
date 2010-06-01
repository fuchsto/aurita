
require('aurita')
require('aurita/model')

module Aurita
module GUI

  class Context_Menu_Button_Bar < DelegateClass(Element)

    def initialize(highlight_element_id)
      element = HTML.div(:id    => "#{highlight_element_id}_wrap", 
                         :class => :context_menu_button_bar, 
                         :style => 'display: none;') { 
      }
      super(element)
    end

  end

  # Adds a context menu to a GUI element, depending on a given 
  # Aurita::Model instance (entity). 
  # When parameter :show_button is defined, an additional button 
  # will be displayed when hovering the element, which shows the 
  # context menu on left click. 
  #
  # Usage: 
  #   
  #    article = Article.get(234)
  #    Context_Menu_Element.new(:entity => article) { 
  #      HTML.div.article { article.title } 
  #    } 
  #
  # or 
  #
  #    Context_Menu_Element.new(article, :show_button => true) { article.title }
  #
  # or
  #  
  #    Context_Menu_Element.new(HTML.div { article.title }, :entity => article)
  # 
  class Context_Menu_Element < DelegateClass(Element)

    def initialize(*args, &block)
      if args.at(0).is_a? Aurita::Model then
        entity  = args.at(0)
        params  = args.at(1)
        element = yield 
      elsif args.at(0).is_a? GUI::Element then
        element = args.at(0)
        params  = args.at(1)
        entity  = params[:entity] if params
      elsif args.at(0).is_a? Hash then
        params  = args.at(0)
        entity  = params[:entity] if params
        element = yield 
      end

      if !element.respond_to?(:dom_id) then
        element = HTML.div(:id => entity.dom_id) { element }
      end

      params ||= {}
      type = params[:type]

      additional_params      = params[:params] 
      additional_params    ||= {} 
      highlight_element_id   = params[:highlight_id]
      highlight_element_id ||= element.dom_id()
      result = ""
      if !params[:id] && entity then
        params[:id] = entity.dom_id
      end
      
      highlight_element_id ||= params[:id] 
      
      menu_params = ''
      if entity then
        menu_params = entity.url_key
        type = entity.model_name
      end
      type = type.to_s if type
      additional_params.each_pair { |k,v|
        menu_params << "&#{k.to_s}=#{v.to_s}"
      }
      
      element.id = "#{params[:id]}" unless element.dom_id()

      if params[:id] then
        own_id               = "context_#{params[:id]}"
        highlight_element_id = own_id
      end

      button_bar  = Context_Menu_Button_Bar.new(highlight_element_id)
      edit_button = HTML.div(:class   => :context_menu_button, 
                             :onclick => "Aurita.open_context_menu(); ") { 
          HTML.img(:src => '/aurita/images/icons/edit_button.gif') 
      }

      if params[:add_context_buttons] then 
        button_bar << edit_button
        button_bar << params[:add_context_buttons]
      elsif params[:context_buttons] then
        button_bar << params[:context_buttons]
      else
        button_bar << edit_button
      end
      
      type_css_class = type.gsub('::','__')

      if params[:show_button] == true then
        element = HTML.div(:class => [ type_css_class, :context_menu_element ] ) { 
          button_bar + element 
        } 
      elsif params[:show_button] == :append then
        element << HTML.div(:class => [ type_css_class, :context_menu_element ] ) { 
           button_bar
        } 
      elsif params[:show_button] == :prepend then
        element.prepend(HTML.div(:class => [ type_css_class, :context_menu_element ] ) { 
          button_bar  
        })
      end

      element.add_css_class(params[:class]) if params[:class]

      element.id = own_id if own_id
      
      element.onmouseout  = "Aurita.context_menu_out(this);"
      element.onmouseover = "Aurita.context_menu_over('#{type}', '#{menu_params}', '#{highlight_element_id}');"
      
      super(element)
    end
    
  end # class

end # module
end # module

