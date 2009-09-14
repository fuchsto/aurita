
require('aurita')
Aurita.import_module :gui, :module

module Aurita
module GUI

  class Box < Element
    
    attr_accessor :header, :body, :collapsed, :header_style, :type
    
    def initialize(args)
      args[:tag]    = :div
      @collapsed    = false
      @header_style = 'font-size: 13px;' unless args[:class]
      @header_class = 'header'
      @type         = args[:type]
      @type       ||= :none
      @context_menu_params   = args[:params]
      @context_menu_params ||= {}
      args[:id]     = 'box_' << @@element_count.to_s unless args[:id]
      super(args)
    end

    def string()
      @body = @body.join(' ') if @body.instance_of? Array

      if @collapsed then
        collapse_icon = HTML.img(:src => "/aurita/images/icons/plus.gif",
                                 :id  => "collapse_icon_#{dom_id()}")
      else
        collapse_icon = HTML.img(:src => "/aurita/images/icons/minus.gif",
                                 :id  => "collapse_icon_#{dom_id()}")
      end
      header = HTML.div.box_header(:id => dom_id().to_s+'_header', :style => 'cursor: pointer;') { 
                 HTML.div.header(:style => "#{@header_style.to_s} float:left; clear: none;") { @header.to_s } + 
                 HTML.div(:style => 'clear: none; float: right; cursor: pointer;') { collapse_icon }
               }
      header.onclick = "Aurita.GUI.toggle_box('#{attrib[:id]}');"
      header.add_css_class("#{@type}_header") if @type

      header = Context_Menu_Element.new(header, :type => @type, :highlight_id => dom_id(), :params => @context_menu_params) unless @type == :none

      body_args = @attrib.dup
      body_args[:type]    = "#{@type}_body" if @type
      body_args[:class]   = 'box_body ' 
      body_args[:class]  << "#{@type}_body" if @type

      # Wrapping div is necessary for script.aculo.us SlideUp/Down effects
      body_args[:content] = HTML.div { @body }
      body_args[:style]   = 'display: none; ' if @collapsed
      body_args[:id]      = dom_id().to_s + '_body'
      body = Element.new(body_args) 

      set_content(header.string + body.string) # + '<div style="clear: both;"></div>' )
      super() # + '<div style="clear: both;"></div>'
    end # def

  end # class 
    
end # module
end # module
