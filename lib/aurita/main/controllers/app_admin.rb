
require('aurita/controller')

Aurita::Main.import_controller :hierarchy_entry

module Aurita
module Main

  class App_Admin_Controller < App_Controller

    guard_interface(:all) { Aurita.user.is_admin? } 
    
    def system_box
      box          = Box.new(:type => :system, :class => :topic, :id => :admin_tools_box)
      box.header   = tl(:admin_tools)

      body         = HTML.div.toolbar { 
        Toolbar_Button.new(:icon   => :tags, 
                           :action => 'Tag_Blacklist/edit') { 
          tl(:edit_tags)
        } + 
        Toolbar_Button.new(:icon   => :synonyms, 
                           :action => 'Tag_Synonym/edit') { 
          tl(:edit_synonyms)
        } 
      }

      body        += plugin_get(Hook.admin.toolbar_buttons)
      box.body     = body
      return box
    end
    
    def left
      puts plugin_get(Hook.admin.left.top).map { |component| component.string } 
      puts plugin_get(Hook.admin.left).map { |component| component.string } 
      puts plugin_get(Hook.admin.left.hierarchies, :perspective => 'ADMIN').map { |h| h.string } 
    end
    
    def main
      puts plugin_get(Hook.admin.workspace.top).map { |component| component.string } 
      puts plugin_get(Hook.admin.workspace).map { |component| component.string } 
    end
    
    def locked_users_box
      box = Box.new(:type => :box, :class => :topic, :id => :locked_users_box)
      box.header = tl(:locked_users)
      body = Array.new
      locked_users = User_Profile.all_with((User_Group.atomic == 't') & 
                            (User_Login_Data.deleted == 'f') & 
                            (User_Login_Data.locked == 't')).sort_by(:surname, :asc).to_a

      return unless locked_users && locked_users.length > 0

      locked_users.each { |user|
        if user.user_group_id != '0' then
          user = Context_Menu_Element.new(HTML.a.entry(:onclick => link_to(user, 
                                                                           :controller => 'User_Login_Data', 
                                                                           :action => :update)) { 
                                            user.surname.capitalize + ' ' + user.forename.capitalize 
                                          }, 
                                          :entity => user)
          body << HTML.li { user } 
        end
      }
      box.body = HTML.div { body }
      box.collapsed = true
      box
    end
    
  end # class
  
end # module
end # module

