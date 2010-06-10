
require('aurita-gui/element')
require('aurita-gui/html')

module Aurita
module GUI

  class Text_Button < Element
    include Link_Helpers

    attr_accessor :icon, :label, :action

    def initialize(params={}, &block)
      params[:tag] = :a
      @icon   = params[:icon]
      @label  = params[:label]
      @label  = yield if block_given?
      @action = params[:action]
      params.delete(:icon)
      params.delete(:label)
      params[:class] = [ params[:class] ] unless params[:class].is_a?(Array)
      params[:class] << :button
      params[:class] << :icon_button if @icon
      params[:class] << @icon if @icon
      params[:onclick] = "#{link_to(:action => @action)} return false;" if @action
      params.delete(:action)

      params[:href] = "/aurita/#{@action}" if @action

      super(params)

      button = HTML.div.left { 
                 HTML.div.right {
                   HTML.div.center { 
                     HTML.div.icon { } + HTML.div.label { @label }
                   }
                 }
               }
      
      set_content(button)
    end
    
  end

end
end

