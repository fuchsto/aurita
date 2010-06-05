
require('aurita')
require('aurita-gui/element')
Aurita.import_module :gui, :icon
Aurita.import_module :gui, :link_helpers
Aurita.import_module :gui, :text_button

module Aurita
module GUI

  class Toolbar_Button < Text_Button

    def initialize(params, &block)
      super(params, &block)
      add_css_class(:toolbar_button)
    end

  end

end
end

