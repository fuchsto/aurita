
require('aurita-gui/element')
require('aurita-gui/html')

module Aurita
module GUI

  class Text_Button < Element
    include Link_Helpers

    attr_accessor :icon, :label, :action

    def initialize(params={}, &block)
      params[:tag] = :a unless params[:tag]
      @icon     = params[:icon]
      @label    = params[:label]
      @label  ||= yield if block_given?
      @action   = params[:action]
      params.delete(:icon)
      params.delete(:label)
      params[:class] = [ params[:class] ] unless params[:class].is_a?(Array)
      params[:class] << :button
      params[:class] << :icon_button if @icon
      params[:class] << @icon if @icon
      params[:class] << :nolabel unless @label
      params[:onclick] = "#{link_to(:action => @action)} return false;" if @action
      params.delete(:action)

      params[:href] = params[:link] if params[:link]
      params[:href] = "/aurita/#{@action}" if @action

      super(params)

      set_content(button())
    end

    def button
      inner  = []
      if @label then
        inner  << HTML.div.icon { '&nbsp;' } if @icon
        inner  << HTML.div.label { @label } 
      else
        inner  << HTML.div(:class => [ :icon, :icon_nopadding]) { '&nbsp;' } if @icon
      end
      
      HTML.div.left { 
        HTML.div.right {
          HTML.div.center { 
            inner
          }
        }
      }
    end
    
  end

end
end

