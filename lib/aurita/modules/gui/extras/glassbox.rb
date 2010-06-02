
require('aurita')
require('aurita-gui/widget')

module Aurita
module GUI

  class Glassbox < Aurita::GUI::Widget

    def initialize(params={}, &block)
      @params = params
      @params[:class] = [] unless @params[:class]
      @params[:class] = [ @params[:class] ] unless @params[:class].is_a?(Array)
      @params[:class] << :glassbox
      @dom_id        = @params[:id]
      @body_dom_id   = @params[:body_id]
      @body_dom_id ||= "#{@dom_id}_body"
      @body_class    = [ @params[:body_class] ].flatten
      @body_class  ||= []
      @body_class << :glassbox_content_body
      @params.delete(:body_class)
      @content       = yield if block_given?
      @content     ||= []
      super()
    end

    def element

      HTML.div(@params) {
        HTML.div.glassbox_header { 
          HTML.div.glassbox_header_tl { HTML.div.glassbox_header_tr { ' ' } }
        } + 
        HTML.div.glassbox_content { HTML.div.top { 
          HTML.div.glassbox_content_left { HTML.div.top { 
            HTML.div.glassbox_content_right { HTML.div.top { 
              HTML.div(:id    => @body_dom_id, 
                       :class => @body_class) {
                @content + HTML.div(:style => 'clear: both;') { } 
              }
            }}
          }}
        }} + 
        HTML.div.glassbox_footer { 
          HTML.div.glassbox_footer_tl { HTML.div.glassbox_footer_tr { ' ' } }
        } 
      }

    end

  end
  
end
end

