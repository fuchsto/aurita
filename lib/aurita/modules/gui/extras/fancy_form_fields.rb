
require('aurita-gui/form/input_field')
require('aurita-gui/form/file_field')
require('aurita-gui/form/select_field')

module Aurita
module GUI

  class Input_Field < Form_Field
    def decorated_element
      HTML.div.left { HTML.div.right { HTML.div.center { element() } } } 
    end
  end

  class File_Field < Form_Field
    def element
      HTML.div.left { HTML.div.right { HTML.div.center { HTML.input(@attrib) } } } 
    end
  end

  class Select_Field < Options_Field
    def decorated_element
      HTML.div.left { HTML.div.right { HTML.div.center { element() } } }
    end
  end

end
end

