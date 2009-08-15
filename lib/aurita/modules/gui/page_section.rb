
require('aurita-gui')
require('aurita-gui/widget')

module Aurita
module GUI

  class Page_Section < Widget
    def initialize(params={}, &block)
      @header  = params[:header]
      params.delete(:header)
      @content = yield
      super()
    end

    def element
      HTML.div.section_header { 
        HTML.div.section_header_left { HTML.h2 { @header } } + 
        HTML.div(:style => 'clear: both;') +
        HTML.div.section_content { @content } 
      }
    end
  end

end
end

