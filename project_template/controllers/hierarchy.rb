require('aurita/controller')
Aurita::Main.import_model :hierarchy
Aurita::Main.import_model :hierarchy_entry
Aurita::Main.import_model :hierarchy_category
Aurita.import_module :gui, :hierarchy

Aurita::Main.import_controller :hierarchy

module Aurita
module Default

  class Hierarchy_Controller < Aurita::Main::Hierarchy_Controller

    def hierarchy_boxes(category) 
      hierarchy_list = []
      count = 0
      Hierarchy.all_with((Hierarchy.category == category) & (Hierarchy.accessible)).each { |h|
        map = Hierarchy_Map.new(Hierarchy_Entry.all_with(Hierarchy_Entry.hierarchy_id == h.hierarchy_id).entities)
        dec = Hierarchy_Entries_Default_Decorator.new(map)
        if dec.string || Aurita.user.is_registered? then
          hierarchy_list << dec.string
        end
        count += 1
      }
      HTML.div.hierarchy { hierarchy_list }
    end

  end # class
  
end # module
end # module

