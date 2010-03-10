
require('aurita/model')
Aurita::Main.import_model :user_group
Aurita::Main.import_model :category
Aurita.import_module :accessor_strategy
Aurita::Main.import_model :strategies, :category_based_accessor

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
      args[:write_permission] = true if args[:write_permission].nil?
      args[:read_permission]  = true if args[:read_permission].nil?
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
          uid.where((User_Category.category_id == category_id) & 
                    (User_Profile.hidden == 'f') & (User_Profile.locked == 'f'))
        }))
        u.order_by(User_Profile.surname, :asc)
      }
    end # }}}

  end 

  class User_Group < Aurita::Model
    include Accessor_Strategy 

    use_accessor_strategy(Category_Based_Accessor, 
                          :managed_by => User_Category, 
                          :mapping    => { :user_group_id => :category_id})

  end

end 
end

