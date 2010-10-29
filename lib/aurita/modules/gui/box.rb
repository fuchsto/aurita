
require('aurita')
Aurita.import_module :gui, :module

module Aurita
module GUI

  class Box < Widget
    
    element_partials :header, :body, :toolbar
    element_properties :sortable, :type, :entity

    attr_reader :collapsed, :header_style, :type, :sortable
    
    def initialize(args)
      @entity       = args[:entity]
      @collapsed    = args[:collapsed]
      @header_class = 'header'
      @sortable     = args[:sortable]
      @sortable     = false unless Aurita.user.is_registered?   
      @type         = args[:type]
      @type       ||= @entity.model_name if @entity
      @type       ||= :none
      @header       = args[:header]
      @toolbar      = args[:toolbar]
      @context_menu_params   = args[:params]
      @context_menu_params ||= {}
      @params       = args
      @params.delete(:collapsed)
      @params.delete(:sortable)
      @params.delete(:entity)
      @params.delete(:header)
      @params.delete(:toolbar)
      @params.delete(:type)

      unless Aurita.runmode == :production
        raise ::Exception.new("Must provide DOM id for GUI::Box") unless @params[:id]
      end

      super()
    end

    def element
      toggle = "Aurita.GUI.toggle_box('#{@params[:id]}');"
      
      if @collapsed then
        collapse_icon = HTML.img(:src     => "/aurita/images/icons/plus.gif",
                                 :id      => "collapse_icon_#{@params[:id]}")
      else
        collapse_icon = HTML.img(:src     => "/aurita/images/icons/minus.gif",
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

      header = HTML.div.box_header(:id => "#{@params[:id]}_header") { 
                 HTML.div.box_header_label { @header.to_s } + 
                 HTML.div.box_header_buttons{ header_buttons }
               }
      header.onclick = toggle

      if @type && @type != :none then
        header.add_css_class("#{@type}_header") 
        header = Context_Menu_Element.new(header, 
                                          :type         => @type, 
                                          :highlight_id => @params[:id], 
                                          :params       => @context_menu_params) 
      end

      if @toolbar then
        add_css_class(:toolbar)
      end

      tools_args = @params.dup
      tools_args[:class]  = [ :box_toolbar ]
      tools_args[:class] << "#{@type}_toolbar" if @type
      tools_args[:id]     = "#{@params[:id]}_toolbar"
      tools = HTML.div(tools_args) { HTML.div { @toolbar } }

      body_args = @params.dup
      body_args[:type]    = "#{@type}_body" if @type
      body_args[:class]   = [ :box_body ]
      body_args[:class]  << "#{@type}_body" if @type
      
      # Wrapping div is necessary for script.aculo.us SlideUp/Down effects
      body_args[:style]   = 'display: none; ' if @collapsed
      body_args[:id]      = "#{@params[:id]}_body"
      body = HTML.div(body_args) { HTML.div { @body } }

      return HTML.div(@params) { header + tools + body }
    end # def

  end # class 
    
end # module
end # module

