
require('aurita')
require('aurita-gui/widget')
Aurita.import_module :gui, :box
Aurita.import_module :gui, :context_menu

module Aurita
module GUI

  # Usage: 
  #
  #  Accordion_Box.new(:header => 'Header here', 
  #                    :id     => :test, 
  #                    :type   => :hierarchy, 
  #                    :params => { :hierarchy_id => 5 } ) { 
  #    'Body here' 
  #  }
  #
  class Accordion_Box < Box

    @@accordion_box_count = 0

    def initialize(params={}, &block)
      @params       = params
      @level        = params[:level]
      @level      ||= 0
      @onclick      = @params[:onclick]
      @params.delete(:level)
      @params.delete(:onclick)
      @context_menu = params[:context_menu] != false
      @params[:id]  = "accordion_box_#{@@accordion_box_count}" unless @params[:id]

      super(@params, &block)
      add_css_classes(:accordion_box, :topic, "accordion_box_#{@level}")

      @@accordion_box_count += 1
    end

    def element
      accordion_box = HTML.div(@params) { }
      group  = "accordion_box_#{@level}"

      header = HTML.a(:class => [ :box_header, 
                                  :accordion_box_header , 
                                  "#{group}_header"
                                ], 
                      :onclick => @onclick) { @header.to_s } 
      header.id = "#{accordion_box.dom_id()}_header" if accordion_box.dom_id
      header.add_css_class("#{@type}_header") if @type

      if @type && @with_context_menu then
        header = Context_Menu_Element.new(header, 
                                          :type => @type, 
                                          :highlight_id => accordion_box.dom_id, 
                                          :params => @context_menu_params) 
      end

      body   = HTML.div(:class => [ :box_body, 
                                    :accordion_box_body, 
                                    "#{group}_body" 
                                  ], 
                        :style => 'overflow: hidden; display: none; ') { @body }
      body.id = accordion_box.dom_id.to_s + '_body' if accordion_box.dom_id

      accordion_box << header
      accordion_box << body

      return accordion_box
    end

    def js_initialize
      group  = "accordion_box_#{@level+1}"
      
      "new accordion('#{dom_id}_body', { 
        classNames: { 
          content: '#{group}_body', 
          toggle: '#{group}_header', 
          toggleActive: '#{group}_header_active'
        }
      });" 
    end

  end

end
end

