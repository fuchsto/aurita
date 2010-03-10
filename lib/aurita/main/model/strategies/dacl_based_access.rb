
require('aurita')
Aurita::Main.import_model :content_permissions
Aurita::Main.import_model :content_hierarchy
Aurita::Main.import_model :user_dacl
Aurita::Main.import_model :strategies, :abstract_access_strategy

module Aurita
module Main

  class DACL_Based_Access < Abstract_Access_Strategy

    # Whether user has requested permission on given Content instance. 
    # Returns true in the following cases: 
    #
    # - Implicit rules
    #    - Admin privilege: 
    #      User has role permission 'admin' or 'superadmin'. 
    #    - Author privilege: 
    #      Content has been created by this user. 
    #
    # - Explicit rules 
    #   There is no ACE denying this permission to the user or one of 
    #   its user groups and at least one of the following rules is met: 
    #
    #    - Immediate: 
    #      User has explicit ACE, mapping his user group id to the content 
    #      instance and containing the requested permission. 
    #    - Group permission inheritance: 
    #      User is member of a user group that has an explicit ACE, mapping 
    #      the user group id to the content instance and containing the 
    #      requested permission. 
    #    - Object permission inheritance: 
    #      There is an ACE for the user with inheritable flag set and mapped 
    #      to one of the content's parent content instances, containing 
    #      the requested permission. 
    #    - Object and Group permission inheritance: 
    #      There is an ACE mapping one of the content's parent content 
    #      instances to one of the user groups the user is member of, 
    #      containing the requested permission. 
    #    - User has been granted exceptional read permissions via Content_Permission. 
    #
    # Otherwise returns false. 
    #
    def permits_access_for(user, permission)
      return :admin if (user.is_admin?)
      return :owner if (@instance.user_group_id == user.user_group_id)

      return false if denies_access_for(user, permission)

      user_group_id_set = user.user_group_id_stack
      return :explicit if User_DACL.find(1).with((User_DACL.content_id == @instance.content_id) &
                                            (User_DACL.user_group_id.in(user_group_id_set)) & 
                                            (User_DACL.deny == false) & 
                                            (User_DACL.permissions.has_element(permission.to_s))).entity
      content_id_stack  = @instance.content_id_stack
      return :inherit if User_DACL.find(1).with((User_DACL.inherit == true) &
                                            (User_DACL.content_id.in(content_id_stack)) &
                                            (User_DACL.user_group_id.in(user_group_id_set)) & 
                                            (User_DACL.deny == false) & 
                                            (User_DACL.permissions.has_element(permission.to_s))).entity

      return false 
    end


    def denies_access_for(user, permission)
      user_group_id_set = user.user_group_id_stack
      return :explicit if User_DACL.find(1).with((User_DACL.content_id == @instance.content_id) &
                                            (User_DACL.user_group_id.in(user_group_id_set)) & 
                                            (User_DACL.deny == true) & 
                                            (User_DACL.permissions.has_element(permission.to_s))).entity
      content_id_stack  = @instance.content_id_stack
      return :inherit if User_DACL.find(1).with((User_DACL.inherit == true) &
                                            (User_DACL.content_id.in(content_id_stack)) &
                                            (User_DACL.user_group_id.in(user_group_id_set)) & 
                                            (User_DACL.deny == true) & 
                                            (User_DACL.permissions.has_element(permission.to_s))).entity

      return false
    end

    # Alias for 
    #
    #   permits_access_for(user, :r)
    #
    def permits_read_access_for(user)
      permits_access_for(user, :r)
    end

    # Alias for 
    #
    #   permits_access_for(user, :w)
    #
    def permits_write_access_for(user)
      permits_access_for(user, :w)
    end

    def grant(params={})
      obj    = params[:user]
      obj  ||= params[:group]
      perm   = params[:permission]
      perm ||= params[:permissions]
      User_DACL.delete { |ace|
        ace.where(:deny          => 't', 
                  :content_id    => @instance.content_id, 
                  :user_group_id => obj.user_group_id)
      }
      User_DACL.create(:user_group_id => obj.user_group_id, 
                       :content_id    => @instance.content_id, 
                       :permissions   => perm, 
                       :deny          => false,  
                       :inherit       => (params[:inherit] == true))
    end

    def deny(params={})
      obj    = params[:user]
      obj  ||= params[:group]
      perm   = params[:permission]
      perm ||= params[:permissions]
      User_DACL.delete { |ace|
        ace.where(:deny          => 'f', 
                  :content_id    => @instance.content_id, 
                  :user_group_id => obj.user_group_id)
      }
      User_DACL.create(:user_group_id => obj.user_group_id, 
                       :content_id    => @instance.content_id, 
                       :permissions   => perm, 
                       :deny          => true, 
                       :inherit       => (params[:inherit] == true))
    end

  end

end
end

