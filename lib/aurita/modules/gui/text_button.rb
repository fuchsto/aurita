
require('aurita-gui/element')
require('aurita-gui/html')

module Aurita
module GUI

  class Text_Button < Element
    def initialize(params={}, &block)
      params[:tag] = :a
      @icon  = params[:icon]
      @label = params[:label]
      @label = yield if block_given?
      params.delete(:icon)
      params.delete(:label)
      params[:class] = [ params[:class] ] unless params[:class].is_a?(Array)
      params[:class] << :button
      params[:class] << :icon_button if @icon
      super(params)
    end

    def string()
      icon  = HTML.img(:src => "/aurita/images/icons/#{@icon}").string if @icon
      label = HTML.span.button_label { @label }.string if @label

      set_content("#{icon}#{label}")
      super()
    end
  end

end
end

