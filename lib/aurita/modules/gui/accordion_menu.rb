
require('aurita')
require('aurita-gui/widget')
Aurita.import_module :gui, :accordion_box
Aurita.import_module :gui, :context_menu

module Aurita
module GUI

  # Usage: 
  #
  #  Accordion_Menu.new(hierarchies, 
  #                     :id => :my_menu)
  #
  class Accordion_Menu < Widget

    def initialize(hierarchy, params={}, &block)
      @params       = params
      @hierarchy    = hierarchy
      @group_class  = 'accordion_menu'
      @params[:id]  = 'accordion_menu' unless @params[:id]
      @context_menu = params[:context_menu] != false
      @params.delete(:context_menu)
      super()
    end

    def element
      map = Hierarchy_Map.new(@hierarchy.entries)
      HTML.div.accordion_menu(@params) { 
        Hierarchy_Entries_Accordion_Decorator.new(map, 
                                                  :context_menu => @context_menu)
      }
    end

    def js_initialize
      group  = "accordion_box"
      "new accordion('#{dom_id}', { 
        classNames: { 
          content: '#{group}_1_body', 
          toggle: '#{group}_1_header', 
          toggleActive: '#{group}_1_header_active'
        }
      });" 
    end
      
  end

end
end

