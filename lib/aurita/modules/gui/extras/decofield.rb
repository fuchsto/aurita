
require('aurita-gui/element')

module Aurita
module GUI

  # Just wraps the Element's content in three divs 
  # with classes 'left', 'right', 'center', which is 
  # often used for styling fields. 
  #
  class Decofield < Element

    def initialize(params={}, &block)
      params[:tag] = :div
      super(params, &block)
      set_content(element())
      add_css_class(:decofield)
    end

    def element
      HTML.div.left { HTML.div.right { HTML.div.center { @content } } }
    end

  end

end
end


