
require('aurita/controller')
Aurita::Main.import_controller :context_menu
Aurita.import_plugin_model :wiki, :article

module Aurita
module Main

  # Controller for Hierarchy_Entry. 
  #
  # Hooks: 
  #
  # [main.hierarchy_entry.entry_types] expects plugins to return 
  # entry types as Hash like: 
  #
  #   'ENTRY_TYPE' => 'label string'
  #
  class Hierarchy_Entry_Controller < App_Controller

    def add
      form = model_form(:model => Hierarchy_Entry, :action => :perform_add)
      form.fields = [
         Hierarchy_Entry.label, 
         Hierarchy_Entry.entry_type, 
         Content.tags, 
         Hierarchy_Entry.hierarchy_id, 
         Hierarchy_Entry.hierarchy_entry_id_parent, 
         :active_type_element
      ]
      form.add(Hidden_Field.new(:name  => Hierarchy_Entry.hierarchy_id, 
                                :value => param(:hierarchy_id)))
      form.add(Hidden_Field.new(:name  => Hierarchy_Entry.hierarchy_entry_id_parent, 
                                :value => param(:hierarchy_entry_id_parent)))
      form[Hierarchy_Entry.hierarchy_entry_id_parent].hide! 
      
      options = { 'FILTER'     => tl(:filter_entry), 
                  'BLANK_NODE' => tl(:blank_node_entry) }

      plugin_get(Hook.main.hierarchy_entry.entry_types).each { |p|
        options[p[:request]] = p[:label]
      }
      
      type_select = Select_Field.new(:name     => Hierarchy_Entry.entry_type, 
                                     :id       => :hierarchy_entry_type_selector, 
                                     :label    => tl(:context_entry_type), 
                                     :onchange => "Aurita.load_widget($('hierarchy_entry_type_selector').value, { }, 
                                                     Aurita.load_widget_to('active_type_element'));", 
                                     :value    => 'FILTER', 
                                     :options  => options)
      form.add(type_select)

      form.add(GUI::Form_Field.new(:name => :active_type_element) { HTML.div(:id => :active_type_element) {  } } )
      
      return decorate_form(form) 
    end

    def update
      entry = load_instance()
      form = update_form()
      form.fields = [
        :controller, 
        :action, 
        Hierarchy_Entry.hierarchy_entry_id, 
        Hierarchy_Entry.label
      ]
      if entry.entry_type == 'FILTER'
        form.fields << Hierarchy_Entry.interface 
        form[Hierarchy_Entry.interface].value = entry.interface.sub('App_Main/find/key=', '')
        form.fields << Hierarchy_Entry.entry_type
        form[Hierarchy_Entry.entry_type].value = 'FILTER'
      end

      return decorate_form(form)
    end

    def delete
      form = model_form(:model => Hierarchy_Entry, :action => :perform_delete, :instance => load_instance())
      form.readonly! 
      form.fields = [
         Hierarchy_Entry.label
      ]
      return decorate_form(form)
    end

    def perform_add

      hierarchy = Hierarchy.load(:hierarchy_id => param(:hierarchy_id))
      if(param(:entry_type) == 'FILTER') then
        param[:interface] = ('App_Main/find/key=' << param(:tags).to_s) 
      elsif param(:entry_type) == 'BLANK_NODE' then
        param[:interface] = '' 
      else
        # Delegate to entry type handling to plugin
        plugin_call(Hook.main.hierarchy_entry.add_entry, @params)
      end
      param[:entry_type] = ''
      hid = param(:hierarchy_id)
      param[:hierarchy_entry_id_parent] = 0 unless param(:hierarchy_entry_id_parent)
      
      instance = super()
      exec_js("Aurita.load({ element: 'hierarchy_#{hid}_body', action: 'Hierarchy/body/hierarchy_id=#{hid}' });")
    end

    def perform_update
      hid = load_instance().hierarchy_id
      
      plugin_call(Hook.main.hierarchy_entry.delete_entry, load_instance())

      exec_js("Aurita.load({ element: 'hierarchy_#{hid}_body', action: 'Hierarchy/body/hierarchy_id=#{hid}' });")
      if param(:entry_type) == :filter then 
        @params[:interface] = 'App_Main/find/key=' << param(:interface).to_s
      end
      super()
    end

    def perform_delete
      entry = Hierarchy_Entry.load(:hierarchy_entry_id => param(:hierarchy_entry_id))
      # Re-hook children of this entry: 
      Hierarchy_Entry.update { |e|
        e.where(Hierarchy_Entry.hierarchy_entry_id_parent == entry.hierarchy_entry_id) 
        e.set(:hierarchy_entry_id_parent => entry.hierarchy_entry_id_parent)
      }
      hid = entry.hierarchy_id
      super()
      exec_js("Aurita.load({ element: 'hierarchy_#{hid}_body', action: 'Hierarchy/body/hierarchy_id=#{hid}' });")
    end

  end # class
  
end # module
end # module

