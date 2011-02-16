
require('aurita-gui/button')

module Aurita
module GUI

  # Override class Button from aurita-gui
  class Button < Element

  end

  class OS_Button < Element

    def initialize(params={})
      params[:tag] = :button
      label        = params[:label]
      params.delete(:label)
      super(params) { label }
    end

  end

end
end

