
require('aurita/model')
Aurita::Main.import_model :user_group
Aurita::Main.import_model :category

module Aurita
module Main

  # Maps instances of Category to users. 
  # Assocating users and categories is the core principle of Aurita's 
  # permission management. 
  # See documentation for Category for details. 
  #
  class User_Category < Aurita::Model

    table :user_category, :public
    primary_key :user_group_id
    primary_key :category_id

    aggregates Category, :category_id
    aggregates User_Group, :user_group_id

    # Returns Category instances mapped to given User_Group 
    # instance as Array, ordered alphabetically. 
    # User_Group.categories() might be more convenient in most 
    # situations. 
    def self.for_user(user_instance)
    # {{{
      user_category = Category.find(1).with(Category.category_name == user_instance.user_group_name).entity
      Category.select { |c| 
        c.where(Category.category_id.in(User_Category.select(User_Category.category_id) { |cid|
          cid.where(User_Category.user_group_id == user_instance.user_group_id)
        }))
        c.order_by(:category_name, :asc)
      }
    end # }}}

    # Ensures that every new permission to a Category is readonly 
    # at first. 
    def self.before_create(args)
      args[:readonly] = true
      args[:write_permission] = false
      args[:read_permission]  = false
    end

    def self.members_of(cat)
      select { |u|
        u.where(category_id == cat.category_id)
      }
    end
    def self.categories_of(user)
      select { |c|
        c.where(user_group_id == user.user_group_id)
      }
    end

  end

  class Category < Aurita::Model

    # Returns User_Group instances mapped to this Category as Array. 
    def users
    # {{{
      # TODO> Fix double join in Lore and change this to: 
      # User_Category.select { |uc|
      #   uc.join(User_Login_Data).using(:user_group_id) { |u|
      #     u.where((User_Category.category_id == category_id) & (User_Login_Data.locked == 'f'))
      #   }
      # }
      User_Profile.select { |u|
        u.where(User_Profile.user_group_id.in(User_Category.select(User_Category.user_group_id) { |uid|
          uid.where(User_Category.category_id == category_id)
        }))
      }
    end # }}}
  end 

  class User_Group < Aurita::Model

    # Returns private Category of this user. 
    def category
    # {{{
      if !@category then
        @category = Category.find(1).with(:is_private.is('t') & 
                                          :category_id.in(User_Category.select(User_Category.category_id) { |cid| 
                                            cid.where(User_Category.user_group_id == user_group_id)
                                          })).entity
        @category = Category.unassigned_category unless @category
      end
      @category
    end # }}}
    alias own_category category

    # Returns all Category instances mapped to this users as Array. 
    def categories
    # {{{
      if !@categories then
        @categories = User_Category.all_with(User_Category.user_group_id == user_group_id).sort_by(:category_name, :asc).entities
      end
      @categories
    end # }}}
    alias own_categories categories

    # Returns all Category instances this user has write permissions 
    # for as Array, ordered alphabetically. 
    def writeable_categories
    # {{{
      if !@writeable_categories then
        if is_admin? then
          @writeable_categories = Category.all.sort_by(:is_private).sort_by(:category_name, :asc).entities
        else
          @writeable_categories = User_Category.all_with((User_Category.readonly == 'f') & (User_Category.user_group_id == user_group_id)).sort_by(:category_name, :asc).entities
        end
      end
      @writeable_categories
    end # }}}

    # Returns id private Category of this user. Uses User_Group#category(). 
    def category_id
      if category then category.category_id end
    end

    # Returns ids of Category instances this user is mapped to, as unordered 
    # Array. 
    def category_ids
    # {{{
      if !@category_ids then
        @category_ids = User_Category.select_values(User_Category.category_id) { |cid|
          cid.where(User_Category.user_group_id == (user_group_id))
        }
      end
      return @category_ids
    end # }}}

    def may_view_category?(cat_id)
      User_Category.find(1).with((User_Category.category_id == cat_id) & 
                                 (User_Category.user_group_id == user_group_id)).entity
    end
    alias may_view_category may_view_category?
    alias is_in_category may_view_category?
    alias is_in_category? may_view_category?

    # Returns ids of Category instances this user has write permissions for, 
    # as unordered Array. 
    def writeable_category_ids
    # {{{
      if !@writeable_category_ids then
        @writeable_category_ids = User_Category.select_values(User_Category.category_id) { |cid|
          cid.where((User_Category.user_group_id == user_group_id) & (User_Category.readonly == 'f'))
        }
      end
      return @writeable_category_ids
    end # }}}
  end

end 
end

