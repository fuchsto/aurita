
require('aurita-gui/widget')
Aurita.import_module :gui, :link_helpers

module Aurita
module GUI

    class Entity_List < Aurita::GUI::Widget
      include Aurita::GUI
      include Aurita::GUI::Link_Helpers

      def initialize(entities, params = {})
        @entities = entities
        @dom_id   = params[:id]
        super()
      end

      def element
        HTML.ul.no_bullets(:id => @dom_id) {
          @entities.map { |e|
            HTML.li.entity(:id => "#{@dom_id}_#{e.pkey}") {
              HTML.span(:id => "#{@dom_id}_icons_#{e.pkey}") { 
                link_to(e, :action => :update) { 
                  Icon.new(:edit_button)
                } +
                link_to(e, :action => :delete) { 
                  Icon.new(:delete)
                } 
              } +
              link_to(e, :action => :update) { 
                Context_Menu_Element.new(e, :class => :label) {
                  e.label
                }
              } + 
              HTML.div(:style => 'clear: both;')
            }
          }
        }
      end
    end

end
end

