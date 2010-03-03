
require('aurita')
Aurita.import_module :gui, :module

module Aurita
module GUI

  class Box < Widget
    
    element_properties :header, :body
    attr_reader :collapsed, :header_style, :type, :sortable
    
    def initialize(args)
      @entity       = args[:entity]
      @collapsed    = false
      @header_style = 'font-size: 13px;' unless args[:class]
      @header_class = 'header'
      @sortable     = args[:sortable]
      @sortable     = false unless Aurita.user.is_registered?   
      @type         = args[:type]
      @type       ||= @entity.model_name if @entity
      @type       ||= :none
      @context_menu_params   = args[:params]
      @context_menu_params ||= {}
      @params       = args
      @params.delete(:sortable)
      @params.delete(:entity)

      super()
    end

    def element
      toggle = "Aurita.GUI.toggle_box('#{@params[:id]}');"
      
      if @collapsed then
        collapse_icon = HTML.img(:src     => "/aurita/images/icons/plus.gif",
                                 :onclick => toggle, 
                                 :id      => "collapse_icon_#{@params[:id]}")
      else
        collapse_icon = HTML.img(:src     => "/aurita/images/icons/minus.gif",
                                 :onclick => toggle, 
                                 :id      => "collapse_icon_#{@params[:id]}")
      end
      move_icon = HTML.img(:src   => "/aurita/images/icons/move.gif", 
                           :class => "moveable box_sort_handle")
      header_buttons = []
      if @sortable then
        header_buttons = [ move_icon, collapse_icon ]
      else
        header_buttons = collapse_icon
      end

      header = HTML.div.box_header(:id => @params[:id].to_s+'_header', :style => 'cursor: pointer;') { 
                 HTML.div.header(:onclick => toggle, :style => "#{@header_style.to_s} width: 90%; float:left; clear: none;") { @header.to_s } + 
                 HTML.div(:style => 'clear: none; float: right; cursor: pointer;') { header_buttons }
               }
      

      if @type && @type != :none then
        header.add_css_class("#{@type}_header") 
        header = Context_Menu_Element.new(header, 
                                          :type         => @type, 
                                          :highlight_id => @params[:id], 
                                          :params       => @context_menu_params) 
      end

      body_args = @params.dup
      body_args[:type]    = "#{@type}_body" if @type
      body_args[:class]   = 'box_body ' 
      body_args[:class]  << "#{@type}_body" if @type
      
      # Wrapping div is necessary for script.aculo.us SlideUp/Down effects
      body_args[:style]   = 'display: none; ' if @collapsed
      body_args[:id]      = @params[:id].to_s + '_body'
      body = HTML.div(body_args) { HTML.div { @body } }

      return HTML.div(@params) { header + body }
    end # def

  end # class 
    
end # module
end # module

