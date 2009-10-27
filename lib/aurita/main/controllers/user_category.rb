
require('aurita/controller')

module Aurita
module Main

  class User_Category_Controller < App_Controller

    guard_interface(:list, :CUD, :toggle_read_permission, :toggle_write_permission) { Aurita.user.is_admin? }

    def list
      puts list_string(param(:user_group_id))
    end

    def category_list(user_group_id=nil)
      user_group_id ||= param(:user_group_id)
      user = User_Group.load(:user_group_id => user_group_id)
      HTML.div { view_string(:admin_user_category_list, 
                             :user => user) }
    end

    def user_list(category_id=nil)
      category_id ||= param(:category_id)
      category = Category.load(:category_id => category_id)
      HTML.div { view_string(:admin_category_user_list, 
                             :category => category) }
    end

    def index
      return Page.new(:header => tl(:your_categories)) { 
        Aurita.user.readable_categories.map { |c| 
          HTML.div.category_thumb { 
            link_to(c, :controller => 'Category') { c.category_name }
          }
        }
      }
    end

    def perform_delete
      User_Category.delete { |u|
        u.where((u.user_group_id == param(:user_group_id)) & 
                (u.category_id == param(:category_id)))
      }
    end

    def toggle_write_permission
      user_cat = User_Category.find(1).with((User_Category.user_group_id == param(:user_group_id)) & 
                                            (User_Category.category_id == param(:category_id))).entity
      if user_cat.write_permission then
        user_cat.write_permission = false
      else
        user_cat.write_permission = true
      end
      user_cat.commit
    end
    def toggle_read_permission
      user_cat = User_Category.find(1).with((User_Category.user_group_id == param(:user_group_id)) & 
                                            (User_Category.category_id == param(:category_id))).entity
      if user_cat.read_permission then
        user_cat.read_permission = false
      else
        user_cat.read_permission = true
      end
      user_cat.commit
    end

  end

end
end
