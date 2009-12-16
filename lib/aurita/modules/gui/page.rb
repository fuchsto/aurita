
require('aurita-gui')
require('aurita-gui/widget')

module Aurita
module GUI

  class Page < Widget
  include I18N_Helpers

    attr_accessor :header, :tools, :content, :sortable, :script

    def initialize(params={}, &block)
      @header   = params[:header]
      @tools    = params[:tools] 
      @tools    = [ @tools ] if @tools && !@tools.is_a?(Array)
      params.delete(:header)
      @content  = yield
      @script   = @content.script if @content.respond_to?(:script)
      @params   = params
      @sortable = params[:sortable]
      @sortable = false unless Aurita.user.is_registered?
      params.delete(:sortable)
      super()
    end

    def element
      @tools ||= []
      if @sortable then
        @tools << HTML.img(:src => '/aurita/images/icons/move.gif', :class => [ :moveable, :box_sort_handle ])
      end
      tools  = @tools.map { |t| HTML.div.section_header_right { t } } 
      head   = HTML.div.section_header_left { HTML.h1 { @header } } if @header
      head   = tools + head if tools && tools.length > 0
      head ||= []

      HTML.div.section_header(:id => @params[:id]) { 
        head + 
        HTML.div(:style => 'clear: both;') +
        HTML.div.section_content(:id => "#{@params[:id]}_content") { @content } 
      }
    end

  end

end
end

