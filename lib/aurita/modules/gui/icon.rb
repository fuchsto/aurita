
require('aurita-gui/element')

module Aurita
module GUI

  class Icon < Element

    attr_accessor :icon

    def initialize(icon_name, params={})
      @icon = icon_name
      params[:tag] = :img
      params[:src] = "/aurita/images/icons/#{@icon}.gif"
      params[:class] = [ params[:class] ]
      params[:class] << :icon
      super(params)
    end

  end

end
end


