
require('aurita/controller')
Aurita::Main.import_controller :role_permission

module Aurita
module Main

  class Role_Controller < App_Controller

    def form_groups
      [
        Role.role_name
      ]
    end

    def add
      form = add_form(Role)

      form.add(Text_Field.new(:name     => Role.role_name, 
                              :label    => tl(Role.role_name), 
                              :required => true))
      form.add(Boolean_Radio_Field.new(:name  => :is_super_admin, 
                                       :label => tl(:is_super_admin), 
                                       :value => false))
      form.add(Boolean_Radio_Field.new(:name  => :is_admin, 
                                       :label => tl(:is_admin), 
                                       :value => false))

      Plugin_Register.permissions.each_pair { |plugin, permissions|
        permissions.each { |p|
          form.add(p.element)
          form.fields << p.name
        }
      }
      render_form(form, :title => tl(:add_role))
    end

    def update
      perms = {}
      role = load_instance()

      Role_Permission.all_with(Role_Permission.role_id == role.role_id).each { |p|
        (perms[p.name.to_sym] = p) if p.name
      }

      form = update_form(Role)

      role_users = User_Role.all_with(User_Role.role_id == param(:role_id)).sort_by(User_Group.user_group_name, :asc).entities
      user_list  = HTML.ul { } 
      role_users.each { |u|
        user_list << HTML.li { link_to(u) { u.user_group_name } }
      }
      users_box = Box.new(:id => :role_users, :class => :topic_inline, :style => "width: 382px; ")
      users_box.header    = tl(:users)
      users_box.body      = user_list
      users_box.collapsed = true

      puts users_box.string

      form.add(Text_Field.new(:name     => Role.role_name, 
                              :label    => tl(Role.role_name), 
                              :value    => role.role_name, 
                              :required => true))
      is_super_admin = (perms[:is_super_admin])? 't' : 'f'
      is_admin = (perms[:is_admin])? 't' : 'f'

      form.add(Boolean_Radio_Field.new(:name  => :is_super_admin, 
                                       :label => tl(:is_super_admin), 
                                       :value => is_super_admin))
      form.add(Boolean_Radio_Field.new(:name  => :is_admin, 
                                       :label => tl(:is_admin), 
                                       :value => is_admin))

      Plugin_Register.permissions.each_pair { |plugin, permissions|
        permissions.each { |p|
          e = p.element
          if perms[p.name.to_sym] then
            e.value = perms[p.name.to_sym].value 
          else
            e.value = 'f' 
          end
          form.add(e)
          form.fields << p.name
        }
      }
    
      render_form(form, :title => tl(:edit_role))
    end

    def perform_add
      role = super()

      role_id = role.role_id
      Plugin_Register.permissions.each_pair { |plugin, permissions|
        permissions.each { |p|
          if param(p.name).nonempty? && param(p.name).to_s != 'f' then
            Role_Permission.create(:role_id => role_id, 
                                   :name    => p.name, 
                                   :value   => param(p.name))
          end
        }
      }
      exec_js("Aurita.load({ element: 'admin_roles_box_body', action: 'Role/admin_box_body/' }); 
               Aurita.load({ element: 'app_main_content', action: 'App_Main/blank/' }); ")
    end

    def perform_update
      super()

      role_id = param(:role_id)
      Role_Permission.delete { |r|
        r.where(r.role_id == role_id)
      }

      Role_Permission.create(:role_id => role_id, :name => 'is_admin', :value => 't') if (param(:is_admin) == 't')
      Role_Permission.create(:role_id => role_id, :name => 'is_super_admin', :value => 't') if (param(:is_super_admin) == 't')

      Plugin_Register.permissions.each_pair { |plugin, permissions|
        permissions.each { |p|
          if param(p.name).nonempty? && param(p.name).to_s != 'f' then
            rp = Role_Permission.create(:role_id => role_id, 
                                        :name    => p.name, 
                                        :value   => param(p.name))
          end
        }
      }
      exec_js("Aurita.load({ element: 'admin_roles_box_body', action: 'Role/admin_box_body/' }); 
               Aurita.load({ element: 'app_main_content', action: 'App_Main/blank/' }); ")
    end

    def perform_delete
      Role_Permission.delete { |r|
        r.where(r.role_id == param(:role_id))
      }
      super()
      exec_js("Aurita.load({ element: 'admin_roles_box_body', action: 'Role/admin_box_body/' }); 
               Aurita.load({ element: 'app_main_content', action: 'App_Main/blank/' }); ")
    end

    def admin_box_body
      body = Array.new
      body << HTML.button(:class => :icon, :onclick => js.Cuba.load(:action => 'Role/add/')) { 
        HTML.img(:src => '/aurita/images/icons/button_add.gif') + tl(:add_role) 
      }
      list = HTML.ul.single_line_list { } 
      Role.find(:all).sort_by(:role_name).each { |role|
        role_id = role.role_id
        entry = HTML.div { 
                  HTML.a.entry(:onclick => js.Cuba.load(:action => "Role/update/id=#{role_id}")) { 
                     " #{role.role_name}"
                  } 
                }
        list << HTML.li { Context_Menu_Element.new(entry, role) }
      }
      body << list
      HTML.div { body }
    end
    def admin_box
      box = Box.new(:type => :user_role_index, :class => :topic, :id => :admin_roles_box)
      box.header = tl(:roles)
      box.body = admin_box_body
      box
    end


  end

end
end
