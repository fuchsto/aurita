
require('aurita')
Aurita::Main.import_model :content_permissions
Aurita::Main.import_model :strategies, :abstract_content_access

module Aurita
module Main

  class Category_Based_Content_Access < Abstract_Content_Access

    # Whether user has read permissions on given Content instance. 
    # Returns true in the following cases: 
    # - User is admin. 
    # - Content instance is mapped to a public category. 
    # - Content instance and user are mapped to at least one common Category. 
    # - User has been granted exceptional read permissions via Content_Permission. 
    #
    def permits_read_access_for(user)
      return true if (user.is_admin? || (@content.user_group_id == user.user_group_id))
      return true if (user.readable_category_ids() & (@content.category_ids)).length > 0

      permissions = Content_Permissions.all_with(Content_Permissions.content_id == @content.content_id).entities
      permissions.each { |p|
        return true if p.user_group_id == user.user_group_id
      }
      return false 
    end

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
    def permits_write_access_for(user)
      return true if (user.is_admin? || (@content.user_group_id == user.user_group_id))
      return false if @content.locked 
      return true if ((user.writeable_category_ids() & (@content.category_ids)).length > 0)

      permissions = Content_Permissions.all_with(Content_Permissions.content_id == @content.content_id).entities
      permissions.each { |p|
        return true if (p.user_group_id == @content.user_group_id) && !p.readonly
      }
      return false 
    end

  end

end
end

