
require('aurita/model')

Aurita::Main.import_model :content_category
Aurita::Main.import_model :user_category
Aurita::Main.import_model :role
Aurita::Main.import_model :user_group
Aurita::Main.import_model :content_permissions

module Aurita
module Main

  class Role_Permission < Aurita::Model
    table :role_permission, :internal
    primary_key :role_permission_id, :role_permission_id_seq
    
    has_a Role, :role_id

    add_output_filter(:value) { |v|
      if (v == 't') then 
        true
      elsif (v == 'f') then 
        false
      else 
        v
      end
    }
    add_input_filter(:value) { |v|
      if v == true then
        't'
      elsif v == false then
        'f'
      else 
        v
      end
    }
  end

  class User_Group < Aurita::Model
    
    # Returns true if user is registered, false otherwise (guest user 
    # with user_group_id '0'). 
    def is_registered?
      ((!user_group_id.nil?) && (user_group_id != 0))
    end

    # Whether this user is allowed to perform a specific operation. 
    # Permission sets are defined in the plugins' permission.rb file. 
    #
    # Example: 
    #
    #   if Aurita.user.has_permission(:some_permission) then 
    #     ...
    #   end
    #
    # Or especially when guarding Controller methods: 
    #
    #   class Some_Controller < Aurita::Plugin_Controller
    #     guard_interface(:delete, :perform_delete) { Aurita.user.may(:delete_something) }
    #     ...
    #   end
    #
    # A user's permission set is cached for one dispatch, so changed on 
    # permissions will not be active in the running request. 
    #
    def has_permission(perm)
    # {{{
      perm = perm.to_sym
      if @role_permissions.nil? || @role_permissions[perm].nil? then
        perms = Role_Permission.select { |rp| 
          rp.join(User_Role).on(Role_Permission.role_id == User_Role.role_id) { |urp|
            urp.where((User_Role.user_group_id == user_group_id) &
                      ((urp.value == 'true') | (urp.value == 't')) & 
                      (urp.name == perm.to_s))
          }
        }.first
        @role_permissions = Hash.new unless @role_permissions
        if perms.nil? then
          @role_permissions[perm] = false
        else
          @role_permissions[perm] = true
        end
      end
      (@role_permissions[perm] == true)
    end # }}}
    alias has_permission? has_permission
    alias may has_permission
    alias may? has_permission
    alias permission has_permission

    # Wheter this user is a super admin. Short for #has_permission(:is_super_admin)
    def is_super_admin?
      ((!user_group_id.nil?) && has_permission(:is_super_admin))
    end
    
    # Whether this user is an admin. Short for #has_permission(:is_admin)
    def is_admin?
      ((!user_group_id.nil?) && has_permission(:is_admin))
    end

  end

end
end

