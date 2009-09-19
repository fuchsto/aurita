
require('aurita/controller')

Aurita::Main.import_controller :hierarchy_entry

module Aurita
module Main

  class App_Admin_Controller < App_Controller

    guard_interface(:all) { Aurita.user.is_admin? } 

    def system_box
      box            = Box.new(:type => :system, :class => :topic)
      box.header     = tl(:admin_tools)
      edit_tags      = HTML.a(:class => :icon, :onclick => link_to(:controller => 'Tag_Blacklist', 
                                                                   :action => :edit)) { 
        HTML.img(:src => '/aurita/images/icons/tags.gif') + tl(:edit_tags) 
      }
      edit_synonyms  = HTML.a(:class => :icon, :onclick => link_to(:controller => 'Tag_Synonym', 
                                                                   :action => :edit)) { 
        HTML.img(:src => '/aurita/images/icons/synonym.gif') + tl(:edit_synonyms) 
      }
      plugin_buttons = plugin_get(Hook.admin.toolbar_buttons)
      box.body       = [ edit_tags, edit_synonyms ] + plugin_buttons
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
      box = Box.new(:type => :box, :class => :topic)
      box.header = tl(:locked_users)
      body = Array.new
      User_Profile.all_with((User_Group.atomic == 't') & 
                            (User_Login_Data.deleted == 'f') & 
                            (User_Login_Data.locked == 't')).sort_by(:surname, :asc).each { |user|
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

