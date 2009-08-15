
require('aurita')
require('aurita/model')

module Aurita
module GUI

  class Context_Menu_Element < DelegateClass(Element)

    def initialize(element, *args)
      if args.at(0).kind_of? Aurita::Model then
        entity = args.at(0)
        params = args.at(1)
      else 
        params = args.at(0)
        entity = params[:entity]
      end
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
      element.onmouseout  = "context_menu_out(this);"
      element.onmouseover = "context_menu('#{type}', '#{menu_params}', '#{highlight_element_id}');"
      super(element)
    end
    
  end # class

end # module
end # module

