
require('aurita/controller')
Aurita::Main.import_controller :hierarchy_entry
Aurita.import_module :context_menu_helpers

module Aurita
module Main

  class Context_Menu_Controller < App_Controller
  include Aurita::Context_Menu_Helpers

  public

    def site_start
    end
    
    def site_my_base
      header('My Base')
      entry(:add_hierarchy, 'Hierarchy/add/category=MY_BASE', {:app_left_column => 'App_Main/left/'})
    end

    def site_my_place
      header('My Place')
      entry(:add_hierarchy, 'Hierarchy/add/category=MY_PLACE', {:app_left_column => 'App_Main/left/'})
    end

    def site_general
      header('Allgemeines')
      entry(:add_hierarchy, 'Hierarchy/add/category=GENERAL', {:app_left_column => 'App_Main/left/'})
    end

    def site_news
      header('Aktuelles')
      entry(:add_hierarchy, 'Hierarchy/add/category=NEWS', {:app_left_column => 'App_Main/left/'})
    end

    def site_media
    end

    def site_expert
      header('Expert')
      entry(:add_hierarchy, 'Hierarchy/add/category=EXPERT', {:app_left_column => 'App_Main/left/'})
    end

    def tag()
      header('Tag options')
      tag = param(:tag)
      entry("find articles with tag '#{tag}'", 'Wiki::Article/find_by_tag/tag='+tag)
    end

    def hierarchy()
      
      hierarchy_id = param(:hierarchy_id)
      hid = hierarchy_id
      targets = { "hierarchy_#{hid}_body" => "Hierarchy/body/hierarchy_id=#{hid}" }
      hierarchy = Hierarchy.load(:hierarchy_id => hierarchy_id)
      
      header(tl(:hierarchy) + ': ' << hierarchy.header)
      entry(:add_entry, 'Hierarchy_Entry/add/hierarchy_id='+hierarchy_id, targets)
      entry(:delete_hierarchy, 'Hierarchy/delete/hierarchy_id='+hierarchy_id, targets) if Aurita.user.may(:delete_hierarchies)
      entry(:update_hierarchy, 'Hierarchy/update/hierarchy_id='+hierarchy_id, targets)
      load_entry(:sort_hierarchy, { "hierarchy_#{hid}_body" => "Hierarchy/sort/hierarchy_id=#{hid}" })
         
    end

    def add_content_icons
      hierarchy_entry_id = param(:hierarchy_entry_id)
      targets = {:app_left_column => 'App_Main/left/'}
      icon(:content, 'Context_Menu/add_text_entry/hierarchy_entry_id='+hierarchy_entry_id, targets)
      icon(:form, 'Hierarchy_Entry/add/hierarchy_entry_id='+hierarchy_entry_id, targets)
    end

    def add_text_entry
      render_view('add_text_asset.rhtml', :hierarchy_entry_id => param(:hierarchy_entry_id))
    end

    def hierarchy_entry()

      entry = Hierarchy_Entry.load(:hierarchy_entry_id => param(:hierarchy_entry_id))
      hid = entry.hierarchy_id
      targets = { "hierarchy_#{hid}_body" => "Hierarchy/body/hierarchy_id=#{hid}" }
      header(entry.label)

      entry(:edit_entry, "Hierarchy_Entry/update/hierarchy_entry_id=#{entry.hierarchy_entry_id}", targets)
      entry(:add_sub_entry, "Hierarchy_Entry/add/hierarchy_entry_id_parent=#{entry.hierarchy_entry_id}&hierarchy_id=#{param(:hierarchy_id)}", targets)
      entry(:delete_entry, "Hierarchy_Entry/delete/hierarchy_entry_id=#{entry.hierarchy_entry_id}", targets)

      load_entry(:sort_hierarchy, { "hierarchy_#{hid}_body" => "Hierarchy/sort/hierarchy_id=#{hid}" })
    end

    def category
      cat = Category.load(:category_id => param(:category_id))
      header(tl(:category) + ' ' << cat.category_name)
      load_entry(:show_category, 'app_main_content' => "Category/show/category_id=#{cat.category_id}")
    end

    def role
      role = Role.get(param(:role_id))
      header(tl(:role) + ' ' << role.role_name)
      targets = { :admin_roles_box_body => 'Role/admin_box_body' }
      entry(:delete_role, "Role/delete/role_id=#{role.role_id}", targets)
    end

    def topic_header
      puts 'topic header'
    end
    
    def topic_body
      puts 'topic body'
    end

    def method_missing
    end

  end # class
  
end # module
end # module

