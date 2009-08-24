
require('aurita-gui')
require('aurita-gui/widget')

module Aurita
module GUI

  class Page < Widget
  include I18N_Helpers

    attr_accessor :header, :tools, :content

    def initialize(params={}, &block)
      @header  = params[:header]
      @tools   = params[:tools]
      params.delete(:header)
      @content = yield
      super()
    end

    def element
      tools = HTML.div.section_header_right { @tools } if @tools
      head  = HTML.div.section_header_left  { HTML.h1 { @header } } 
      head  = tools + head if tools
      HTML.div.section_header { 
        head + 
        HTML.div(:style => 'clear: both;') +
        HTML.div.section_content { @content } 
      }
    end
  end

end
end

