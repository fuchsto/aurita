
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
      if perm == :is_super_admin then
        # raise ::Exception.new('find me')
      end
      if @role_permissions.nil? || @role_permissions[perm.to_s].nil? then
        perms = Role_Permission.select { |rp| 
          rp.join(User_Role).on(Role_Permission.role_id == User_Role.role_id) { |urp|
            urp.where((User_Role.user_group_id == user_group_id) &
                      (urp.name == perm.to_s))
          }
        }.first
        @role_permissions = Hash.new unless @role_permissions
        if perms.nil? then
          @role_permissions[perm.to_s] = false
        else
          @role_permissions[perm.to_s] = true
        end
      end
      @role_permissions[perm.to_s] 
    end # }}}
    alias has_permission? has_permission
    alias may has_permission
    alias permission has_permission

    # Wheter this user is a super admin. Short for #has_permission(:is_super_admin)
    def is_super_admin?
      ((!user_group_id.nil?) && has_permission(:is_super_admin))
    end
    
    # Whether this user is an admin. Short for #has_permission(:is_admin)
    def is_admin?
      ((!user_group_id.nil?) && has_permission(:is_admin))
    end

    # Whether user has read permissions on given Content instance. 
    # Returns true in the following cases: 
    # - User is admin. 
    # - Content instance is mapped to a public category. 
    # - Content instance and user are mapped to at least one common Category. 
    # - User has been granted exceptional read permissions via Content_Permission. 
    #
    def may_view_content?(content)
    # {{{
      if !content.is_a? Content then
        content = Content.load(:content_id => content)
        raise ::Exception.new("Could not resolve content for #{content.inspect}") unless content
      end
      return false unless content

      return true if is_admin? or (content.user_group_id == user_group_id)
      return true if (Aurita.user.readable_category_ids & (content.category_ids))

      permissions = Content_Permissions.all_with(Content_Permissions.content_id == content.content_id).entities
      permissions.each { |p|
        return true if p.user_group_id == Aurita.user.user_group_id
      }
      return false 
    end # }}}
    
    # Whether user has permissions to perform changes on given Content instance. 
    # Even if Content instance is locked, returns true in following cases: 
    #
    # - User is admin. 
    # - User is author of Content instance and has read permissions on it. 
    #   (Note that users might lose permissions on a Content they created themselves, 
    #   so read permissions have to be validated in any case). 
    #
    # Otherwise, if Content instance is locked, always returns false. 
    #
    # Returns true if Content instance is not locked and: 
    # - Content instance and user are mapped to at least one common Category the 
    #   user has write permissions for. 
    # - User has been granted exceptional write permissions via Content_Permission. 
    #
    def may_edit_content?(content)
    # {{{
      if !content.is_a? Content then
        content = Content.load(:content_id => content)
        raise ::Exception.new("Could not resolve content for #{content.inspect}") unless content
      end
      return false unless content

      return true if is_admin? or (content.user_group_id == user_group_id)
      return false if content.locked 
      return true if (Aurita.user.writeable_category_ids & (content.category_ids))

      permissions = Content_Permissions.all_with(Content_Permissions.content_id == content.content_id).entities
      permissions.each { |p|
        return true if p.user_group_id == Aurita.user.user_group_id and !p.readonly
      }
      return false if permissions.length > 0
    end # }}}

  end

end

end

