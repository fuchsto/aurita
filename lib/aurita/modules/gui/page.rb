
require('aurita-gui')
require('aurita-gui/widget')

module Aurita
module GUI

  class Page < Widget
  include I18N_Helpers

    attr_accessor :header, :tools, :content, :sortable

    def initialize(params={}, &block)
      @header   = params[:header]
      @tools    = params[:tools] 
      @tools    = [ @tools ] unless @tools.is_a?(Array)
      params.delete(:header)
      @content  = yield
      @params   = params
      @sortable = params[:sortable]
      @sortable = false unless Aurita.user.is_registered?
      params.delete(:sortable)
      super()
    end

    def element
      if @sortable then
        @tools ||= []
        @tools << HTML.img(:src => '/aurita/images/icons/move.gif', :class => [ :moveable, :box_sort_handle ])
      end
      tools = @tools.map { |t| HTML.div.section_header_right { t } } if @tools
      head  = HTML.div.section_header_left  { HTML.h1 { @header } } 
      head  = tools + head if tools
      HTML.div.section_header(:id => @params[:id]) { 
        head + 
        HTML.div(:style => 'clear: both;') +
        HTML.div.section_content(:id => "#{@params[:id]}_content") { @content } 
      }
    end
  end

end
end

