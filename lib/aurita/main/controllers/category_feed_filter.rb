
require('aurita/controller')

module Aurita
module Main

  class Category_Feed_Filter_Controller < Aurita::App_Controller
    
    guard(:CRUD) { Aurita.user.is_admin? }

    def toggle
  
      Category_Feed_Filter.toggle(:user        => Aurita.user, 
                                  :category_id => param(:category_id))

    end

    def update
      user       = User_Group.get(param(:user_group_id))
      filter     = Category_Feed_Filter.for(user)
      categories = user.categories
      HTML.div.listbox { 
        HTML.h4 { tl(:show_updates_in_categories) } + 
        categories.map { |c|
          HTML.div.item { 
            HTML.input(:name       => 'category_id', 
                       :class      => :checkbox, 
                       :type       => :checkbox, 
                       :value      => c.category_id, 
                       :checked    => !filter.include?(c.category_id) || nil, 
                       :style      => 'padding-top: 2px; margin-right: 10px; display: inline; ', 
                       :onchange   => "Aurita.call({ action: 'Category_Feed_Filter/toggle/category_id=#{c.category_id}' });") +
            HTML.div.item_label { c.category_name }
          }
        }
      }
    end

  end

end
end


