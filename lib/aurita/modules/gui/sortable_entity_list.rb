
require('aurita')
Aurita.import_module :gui, :entity_list

module Aurita
module GUI

    class Sortable_Entity_List < Entity_List
      include Aurita::GUI
      include Aurita::GUI::Link_Helpers

      def initialize(entities, params = {})
        @onupdate = params[:onupdate]
        super(entities, params)
      end

      def element
        list = super()
        @entities.each { |e|
          sort_handle = Icon.new(:move_ns, 
                                 :class => :sort_handle)
          list["#{@dom_id}_icons_#{e.pkey}"] << sort_handle
        }
        list
      end
      
      def js_initialize
<<JS
  Sortable.create('#{@dom_id}', { 
    tag: 'li', 
    scroll: window, 
    handle: 'sort_handle', 
    onUpdate: #{@onupdate}
  }); 
JS
      end

    end

end
end

