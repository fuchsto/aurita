require('aurita/controller')
Aurita::Main.import_model :hierarchy
Aurita::Main.import_model :hierarchy_entry
Aurita::Main.import_model :hierarchy_category
Aurita.import_module :gui, :hierarchy
Aurita.import_module :gui, :accordion_box

Aurita::Main.import_controller :hierarchy_entry

module Aurita
module Main

  class Hierarchy_Controller < App_Controller

    def form_groups
      [
        Hierarchy.header, 
        Hierarchy.category, 
        Category.category_id
      ]
    end

    def update
      form = update_form
      form[Hierarchy.category].hidden = true
      category = Category_Selection_List_Field.new()
      category.value = load_instance.category_ids
      form.add(category)
      render_form(form)
    end

    def delete
      form = delete_form
      form[Hierarchy.category].hidden = true
      render_form(form)
    end

    def perform_add
      instance = super()
      Hierarchy_Category.create_for(instance, param(:category_ids))
      after_modification(instance)
    end

    def perform_update
      return unless param(:hierarchy_id)
      return unless Aurita.user.is_admin? 
      super()
      instance = load_instance()
      Hierarchy_Category.update_for(instance, param(:category_ids))
      after_modification(Hierarchy.load(:hierarchy_id => param(:hierarchy_id)))
    end

    def perform_delete
      return unless param(:hierarchy_id)
      return unless Aurita.user.may(:delete_hierarchies)
      hierarchy = load_instance()
      Hierarchy_Entry.delete { |he|
        he.where(he.hierarchy_id == param(:hierarchy_id))
      }
      after_modification(hierarchy)
      super()
    end

    def after_modification(hierarchy)
      category = hierarchy.category
      if category == 'GENERAL' then
        exec_js("Aurita.load({ element: 'app_left_column', action: 'App_General/left/' })")
      elsif category == 'MY_PLACE' then
        exec_js("Aurita.load({ element: 'app_left_column', action: 'App_My_Place/left/' })")
      end
    end


    def list(params)
      params[:perspective] = 'GENERAL' unless params[:perspective]
      hierarchy_boxes(params[:perspective])
    end

    def hierarchy_boxes(category=nil) 
      category ||= 'GENERAL'
      hierarchy_list = []
      count = 0
      Hierarchy.all_with((Hierarchy.category == category) & (Hierarchy.accessible)).each { |h|
        entries = Hierarchy_Entry.all_with(Hierarchy_Entry.hierarchy_id == h.hierarchy_id).entities
        map = Hierarchy_Map.new(entries)
        dec = Hierarchy_Entries_Default_Decorator.new(map)
        if dec.string || Aurita.user.is_registered? then
          box = Accordion_Box.new(:type   => :hierarchy, 
                                  :class  => :topic, 
                                  :id     => "hierarchy_#{h.hierarchy_id}", 
                                  :params => { :hierarchy_id => h.hierarchy_id } )
          box.header = h.header
          box.body   = dec.string
          hierarchy_list << box
        end
        count += 1
      }
      hierarchy_list 
    end

    def perform_reorder
      hid = param(:hierarchy_id)
      position_tree = []
      parse_position_tree("hierarchy_sortable_list_#{hid}", '0', position_tree)
      sortpos = 0
      position_tree.each { |entry|
        entry_id = entry[0]
        entry_parent_id = entry[1]
        Hierarchy_Entry.update { |e|
          e.where(e.hierarchy_entry_id == entry_id) 
          e.set(:hierarchy_entry_id_parent => entry_parent_id, 
                :sortpos => sortpos)
        }
        sortpos += 1
      }
    end

  private 

    def parse_position_tree(param_string, last_parent_entry_id, tree)
      position = 0
      while param(param_string + "[#{position}][id]") do 
        entry_id = param(param_string + "[#{position}][id]")
        tree << [ entry_id, last_parent_entry_id ]
        parse_position_tree(param_string + "[#{position}]", entry_id, tree)
        position += 1
      end
    end

  public

    def list_model(hierarchy_id=nil)
      hierarchy_id = param(:hierarchy_id) unless hierarchy_id
      entries = Hierarchy_Entry.all_with(Hierarchy_Entry.hierarchy_id == hierarchy_id).sort_by(:sortpos, :asc).entities
      entry_map = Hash.new
      for entry in entries do 
        pid = entry.hierarchy_entry_id_parent
        entry_map[pid] = Array.new unless entry_map[pid]
        entry_map[pid] << entry
      end
      return entry_map
    end

    def add
      form = model_form(:model => Hierarchy, :action => :perform_add)
      form.add(Hidden_Field.new(:name => Hierarchy.category.to_s, :value => param(:category)))
      render_form(form)
    end

    def delete
      form = delete_form()
      instance = load_instance()
      form.add(Hidden_Field.new(:name => Hierarchy.category.to_s, :value => param(:category)))
      render_form(form)
      form.add(Hidden_Field.new(:name => Hierarchy.category.to_s, :value => instance.category))
    end

    def sort
      h = Hierarchy.load(:hierarchy_id => param(:hierarchy_id))
      return unless h
      h_id = h.hierarchy_id
      map = Hierarchy_Map.new(Hierarchy_Entry.all_with(Hierarchy_Entry.hierarchy_id == h.hierarchy_id).entities)
      dec = Hierarchy_Entries_Sortable_Decorator.new(map)
      dec.dom_id = "hierarchy_sortable_list_#{h_id}"
      js_init = "reorder_hierarchy_id=#{h_id}; 
                 Sortable.create('hierarchy_sortable_list_#{h_id}', 
                                 { onUpdate: on_hierarchy_entry_reorder, tree: true });"
      icon = HTML.img(:src => '/aurita/images/icons/save.gif', 
                      :style => 'margin-bottom: 4px;', 
                      :onclick => "Cuba.load({ element: 'hierarchy_#{h_id}_body', action: 'Hierarchy/body/hierarchy_id=#{h_id}' }); " )

      exec_js(js_init)
      puts icon + dec.string
    end

    def body
      return unless param(:hierarchy_id)
      h_id = param(:hierarchy_id)
      map = Hierarchy_Map.new(Hierarchy_Entry.all_with(Hierarchy_Entry.hierarchy_id == h_id).entities)
      dec = Hierarchy_Entries_Default_Decorator.new(map)
      puts dec.string
    end

  end # class
  
end # module
end # module

