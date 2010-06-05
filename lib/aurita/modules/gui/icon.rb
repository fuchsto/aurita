
require('aurita-gui/element')

module Aurita
module GUI

  class Icon < Element

    attr_accessor :icon

    def initialize(icon_name)
      @icon = icon_name
      super()
    end

    def string
      HTML.img(:src => "/aurita/images/icons/#{@icon}.gif", :class => :icon)
    end

  end

end
end


