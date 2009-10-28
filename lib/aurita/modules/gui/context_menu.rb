
require('aurita')
require('aurita/model')

module Aurita
module GUI

  # Adds a context menu to a GUI element, depending on a given 
  # Aurita::Model instance (entity). 
  # Usage: 
  #   
  #    article = Article.get(234)
  #    Context_Menu_Element.new(:entity => article) { 
  #      HTML.div.article { article.title } 
  #    } 
  # 
  class Context_Menu_Element < DelegateClass(Element)

    def initialize(element, *args, &block)
      if args.at(0).kind_of? Aurita::Model then
        entity = args.at(0)
        params = args.at(1)
      else 
        params = args.at(0)
        entity = params[:entity]
      end
      element = yield if block_given? 

      params ||= {}
      type = params[:type]

      additional_params      = params[:params] 
      additional_params    ||= {} 
      highlight_element_id   = params[:highlight_id]
      highlight_element_id ||= element.dom_id()
      result = ""
      if !params[:id] && entity then
        params[:id] = entity.model_name.gsub('::','__').downcase + '_' << entity.key.values.join('_')
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
      
      if params[:show_button] then
        element = HTML.div(:class => [ type, :context_menu_element ] ) { 
          HTML.div(:class   => :context_menu_button, 
                   :style   => 'display: none;', 
                   :onclick => "Aurita.open_context_menu(); ", 
                   :id      => "#{highlight_element_id}_wrap") { HTML.img(:src => '/aurita/images/icons/edit_button.gif') } + 
          element 
        } 
      end
      
      element.onmouseout  = "Aurita.context_menu_out(this);"
      element.onmouseover = "Aurita.context_menu_over('#{type}', '#{menu_params}', '#{highlight_element_id}');"
      
      super(element)
    end
    
  end # class

end # module
end # module

