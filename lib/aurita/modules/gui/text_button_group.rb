
require('aurita-gui/element')
require('aurita-gui/html')

Aurita.import_module :gui, :text_button

module Aurita
module GUI

  class Text_Button_Group < Text_Button
    include Link_Helpers
    
    attr_accessor :buttons
    
    def initialize(params={}, &block)
      params[:tag]    = :div
      @buttons        = yield
      params[:class]  = [ params[:class] ] unless params[:class].is_a?(Array)
      params[:class]  << :button_group

      set_id               = "#{params[:id]}_button_set"
      params[:onmouseover] = "Aurita.hover(this);"
      params[:onmouseout]  = "Aurita.unhover(this); "
      params[:onclick]     = "Element.toggle('#{set_id}');"

      super(params)
    end

    def button
      inner  = []
      if @label then
        inner  << HTML.div.icon { '&nbsp;' } if @icon
        inner  << HTML.div.label { @label } 
      else
        inner  << HTML.div(:class => [ :icon, :icon_nopadding]) { '&nbsp;' } if @icon
      end

      dom_id = "#{@attrib[:id]}_button_set"

      @buttons.each { |b| b.add_css_class(:toolbar_button) } 
      
      HTML.div.left { 
        HTML.div.right {
          HTML.div.center { 
            inner + 
            HTML.div.button_set(:id    => dom_id, 
                                        :style => 'display: none;') { 
              HTML.div.button_wrap { @buttons } 
            } 
          }
        }
      }
    end

  end

end
end


