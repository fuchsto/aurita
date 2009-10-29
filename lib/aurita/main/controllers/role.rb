
require('aurita/controller')
Aurita::Main.import_controller :role_permission

module Aurita
module Main

  class Role_Controller < App_Controller

    def form_groups
      []
    end

    after(:perform_add, :perform_update, :perform_delete) { |c|
      c.redirect_to(:controller => 'App_Main', :action => :blank)
      c.redirect(:element => :admin_roles_box_body, :to => :admin_box_body) 
    }

    def add

      perms = {}
      
      form = add_form(Role)
      form.delete_field(Role.role_name)
      
      main_permissions_fieldset = Fieldset.new(:name => :main_role_fieldset, 
                                               :legend => tl(:main_role_fieldset))
      
      main_permissions_fieldset.add(Text_Field.new(:name     => Role.role_name, 
                                                   :label    => tl(Role.role_name), 
                                                   :required => true))
      
      main_permissions_fieldset.add(Boolean_Radio_Field.new(:name  => :is_super_admin, 
                                                            :value => 'false', 
                                                            :label => tl(:is_super_admin)))
      main_permissions_fieldset.add(Boolean_Radio_Field.new(:name  => :is_admin, 
                                                            :value => 'false', 
                                                            :label => tl(:is_admin)))
      form.add(main_permissions_fieldset)
      
      permission_field_names = [ Role.role_name, :is_super_admin, :is_admin ]
      Plugin_Register.permissions.each_pair { |plugin, permissions|
        permission_fields = []
        permissions.each { |p|
          e = p.element
          permission_field_names << e.name
          permission_fields << e
        }
        fieldset = GUI::Fieldset.new(:name   => "fieldset_#{plugin}", 
                                     :legend => Lang.get(plugin, :plugin_name)) { permission_fields }
        form.add(fieldset)
      }
      form.fields = permission_field_names
      form.add(GUI::Hidden_Field.new(:name => :controller, :value => 'Role'))
      form.add(GUI::Hidden_Field.new(:name => :action, :value => 'perform_add'))

      return Page.new(:header => tl(:add_role)) { decorate_form(form) }
    end

    def update
      perms = {}
      role = load_instance()
      
      Role_Permission.all_with(Role_Permission.role_id == role.role_id).each { |perm|
        (perms[perm.name.to_sym] = perm) if perm.name
      }
      
      form = update_form(Role)
      form.delete_field(Role.role_name)
      
      role_users = User_Role.all_with(User_Role.role_id == param(:role_id)).sort_by(User_Group.user_group_name, :asc).entities
      user_list  = HTML.ul { } 
      role_users.each { |u|
        user_list << HTML.li { link_to(u) { u.user_group_name } }
      }
      
      main_permissions_fieldset = Fieldset.new(:name => :main_role_fieldset, 
                                               :legend => tl(:main_role_fieldset))
      
      main_permissions_fieldset.add(Text_Field.new(:name     => Role.role_name, 
                                                   :label    => tl(Role.role_name), 
                                                   :value    => role.role_name, 
                                                   :required => true))
      
      is_super_admin   = perms[:is_super_admin].value if perms[:is_super_admin]
      is_super_admin ||= 'false'
      is_admin         = perms[:is_admin].value if perms[:is_admin]
      is_admin       ||= 'false'
      main_permissions_fieldset.add(Boolean_Radio_Field.new(:name  => :is_super_admin, 
                                                            :label => tl(:is_super_admin), 
                                                            :value => is_super_admin))
      main_permissions_fieldset.add(Boolean_Radio_Field.new(:name  => :is_admin, 
                                                            :label => tl(:is_admin), 
                                                            :value => is_admin))
      form.add(main_permissions_fieldset)
      
      permission_field_names = [ Role.role_name, :is_super_admin, :is_admin ]
      Plugin_Register.permissions.each_pair { |plugin, permissions|
        permission_fields = []
        permissions.each { |p|
          e = p.element
          if perms[p.name.to_sym] then
            e.value = perms[p.name.to_sym].value 
          else
            e.value = false
          end
          permission_field_names << e.name
          permission_fields << e
        }
        fieldset = GUI::Fieldset.new(:name   => "fieldset_#{plugin}", 
                                     :legend => Lang.get(plugin, :plugin_name)) { permission_fields }
        form.add(fieldset)
      }
      form.fields = permission_field_names
      form.add(GUI::Hidden_Field.new(:name => :controller, :value => 'Role'))
      form.add(GUI::Hidden_Field.new(:name => :action, :value => 'perform_update'))
      form.add(GUI::Hidden_Field.new(:name => :role_id, :value => role.role_id))
      
      users_box = Box.new(:id => :role_users, :class => :topic_inline, :style => "width: 382px; ")
      users_box.header    = tl(:users)
      users_box.body      = user_list
      users_box.collapsed = true
      
      return Page.new(:header => tl(:edit_role)) { [users_box.string] + decorate_form(form) } 
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
    end

    def perform_update
      super()

      role_id = param(:role_id)
      Role_Permission.delete { |r|
        r.where(r.role_id == role_id)
      }

      Role_Permission.create(:role_id => role_id, :name => 'is_admin', :value => true) if (param(:is_admin) == 'true')
      Role_Permission.create(:role_id => role_id, :name => 'is_super_admin', :value => true) if (param(:is_super_admin) == 'true')

      Plugin_Register.permissions.each_pair { |plugin, permissions|
        permissions.each { |p|
          if param(p.name).nonempty? && param(p.name).to_s != 'f' then
            rp = Role_Permission.create(:role_id => role_id, 
                                        :name    => p.name, 
                                        :value   => param(p.name))
          end
        }
      }
    end

    def perform_delete
      Role_Permission.delete { |r|
        r.where(r.role_id == param(:role_id))
      }
      super()
    end

    def admin_box_body
      body = Array.new
      body << HTML.a(:class   => :icon, 
                     :onclick => link_to(:add)) { 
        icon_tag(:role) + tl(:add_role) 
      } 
      
      list = HTML.ul.no_bullets { } 
      Role.find(:all).sort_by(:role_name).each { |role|
        role_id = role.role_id
        entry = HTML.div { 
                  HTML.a.entry(:onclick => js.Aurita.load(:action => "Role/update/role_id=#{role_id}")) { 
                     " #{role.role_name}"
                  } 
                }
        list << HTML.li { Context_Menu_Element.new(entry, :entity => role) }
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
