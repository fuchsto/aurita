
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
      @params      = params
      @hierarchy   = hierarchy
      @params[:id] = 'accordion_manu' unless @params[:id]
      super()
    end

    def element
      map = Hierarchy_Map.new(@hierarchy.entries)
      HTML.div.accordion_menu(@params) { 
        Hierarchy_Entries_Accordion_Decorator.new(map)
      }
    end

    def js_initialize
      "new accordion('#{dom_id}', { 
        classNames: { 
          content: '#{dom_id}_body', 
          toggle: '#{dom_id}_header', 
          toggleActive: '#{dom_id}_header_active'
        }
      });" 
    end
      
  end

end
end

