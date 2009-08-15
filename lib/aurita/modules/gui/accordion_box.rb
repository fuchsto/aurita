
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
  class Accordion_Box < Element
    
    attr_accessor :header, :body, :collapsed, :type

    def initialize(params={}, &block)
      @body        = params[:body]
      @body        = yield() if block_given?
      @body      ||= ''
      @header      = params[:header]
      @header    ||= ''
      @collaped    = params[:collapsed]
      @collapsed ||= false
      @type        = params[:type]
      @type      ||= false
      @type        = false if @type == :none
      @attrib      = params
      @context_menu_params   = params[:params]
      @context_menu_params ||= {}
      params[:tag] = :div
      params.delete(:type)
      params.delete(:header)
      params.delete(:body)
      add_css_classes(:accordion_box, :topic)
      super(params)
    end

    def type=(type)
      @type = type 
      @type = false if @type == :none
    end

    def string
      accordion_box = HTML.div(@attrib) { }

      classes = css_classes.map { |c| "#{c}_header" }
      header = HTML.div(:class => classes + [ :box_header, :accordion_box_header ]) { @header.to_s } 
      header.id = accordion_box.dom_id().to_s+'_header' if accordion_box.dom_id
      header.add_css_class("#{@type}_header") if @type

      header = Context_Menu_Element.new(header, 
                                        :type => @type, 
                                        :highlight_id => accordion_box.dom_id, 
                                        :params => @context_menu_params) if @type

      classes = css_classes.map { |c| "#{c}_body" }
      body    = HTML.div(:class => classes + [:accordion_box_body, :box_body], 
                         :style => 'overflow: hidden; display: none; ') { @body }
      body.id = accordion_box.dom_id.to_s + '_body' if accordion_box.dom_id

      accordion_box << header
      accordion_box << body

      return accordion_box
    end

  end

end
end

