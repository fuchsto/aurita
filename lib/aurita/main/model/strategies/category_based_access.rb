
require('aurita')
Aurita::Main.import_model :content_permissions
Aurita::Main.import_model :strategies, :abstract_access_strategy
Aurita::Main.import_model :behaviours, :categorized

module Aurita
module Main

  class Category_Based_Access < Abstract_Access_Strategy

    # Whether user has read permissions on given Content instance. 
    # Returns true in the following cases: 
    # - User is admin. 
    # - Content instance is mapped to a public category. 
    # - Content instance and user are mapped to at least one common Category. 
    # - User has been granted exceptional read permissions via Content_Permission. 
    #
    def permits_read_access_for(user)
      return true if user.is_admin? 
      return true if @instance.respond_to?(:user_group_id) && (@instance.user_group_id == user.user_group_id)
      return false if @instance.respond_to?(:locked) && @instance.locked 
      return false if @instance.respond_to?(:deleted) && @instance.deleted
      return true if ((user.readable_category_ids() & (@instance.category_ids)).length > 0)
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
      return true if user.is_admin? 
      return true if @instance.respond_to?(:user_group_id) && (@instance.user_group_id == user.user_group_id)
      return false if @instance.respond_to?(:locked) && @instance.locked 
      return false if @instance.respond_to?(:deleted) && @instance.deleted
      return true if ((user.writeable_category_ids() & (@instance.category_ids)).length > 0)
      return false 
    end

    # Usage: 
    # (Following parameters for :mapping and :managed_by are defaults and 
    # can be skipped)
    #
    #   Model_Klass.use_access_strategy(Concrete_Content_Access, 
    #                                   :managed_by => Content_Category, 
    #                                   :mapping    => { :content_id => :category_id })
    #
    # 
    def self.on_use(klass, params=false)
      klass.extend(Categorized_Access_Class_Behaviour)
      if params then
        klass.use_category_map(params[:managed_by], params[:mapping])
      end
    end

  end

end
end

