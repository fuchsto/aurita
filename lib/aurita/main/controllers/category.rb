
require('aurita/controller')

module Aurita
module Main

  class Category_Controller < App_Controller

    guard(:CUD) { |controller_instance|
      Aurita.user.is_admin? 
    }
    
    def form_groups
      [
       Category.category_name
      ]
    end

    guard_interface(:perform_delete, :perform_add, :perform_update) { 
      Aurita.user.is_admin? 
    }

    after(:perform_update, :perform_delete) { |c|
      c.redirect_to(:controller => 'App_Main', :action => :blank)
      c.redirect(:element => :admin_categories_box_body, :to => :admin_box_body)
    }

    def add
      form = add_form
      render_form(add_form, :title => tl(:add_category))
    end

    def update
      category_id = param(:category_id)
      components  = plugin_get(Hook.admin.category.show, :category_id => param(:category_id))
      form = view_string(:admin_edit_category, 
                         :category => Category.load(:category_id => param(:category_id)), 
                         :category_users => User_Category_Controller.user_list(category_id), 
                         :category_components => components)
      page = Page.new(:header => tl(:edit_category)) { form }
      page.add_css_class(:form_section)
      page
    end 

    def perform_delete
      new_cat_id = param(:new_category_id)
      # Reassign contents, but do not create duplicate assignments: 
      Content_Category.update { |cc|
        cc.set(:category_id => new_cat_id)
        cc.where((Content_Category.category_id == param(:category_id)) & 
                 (Content_Category.content_id.not_in( 
                    Content_Category.select(:content_id) { |cid|
                      cid.where(Content_Category.category_id == new_cat_id)
                    })
                 )
                )
      }

      Content_Category.delete { |cc|
        cc.where(Content_Category.category_id == param(:category_id))
      }
      User_Category.delete { |cc|
        cc.where(User_Category.category_id == param(:category_id))
      }
      super()
    end

    def perform_add

      check = Category.find(1).with(Category.category_name.ilike("%#{param(:category_name)}%")).entity
      if check then
        exec_js(js.alert(tl(:category_name_already_used)))
        return
      end

      instance = super()

      redirect_to(instance)
    end

    def admin_box_body
      body = Array.new
      body << HTML.a(:class   => :icon, 
                     :onclick => link_to(:add)) { 
        icon_tag(:categories) + tl(:add_content_category) 
      } 
      list = HTML.ul.no_bullets { } 
      Category.all_with((Category.is_private == 'f') & (Category.category_id >= '100')).sort_by(:category_name, :asc).each { |cat|
        cat = Context_Menu_Element.new(HTML.a.entry(:onclick => link_to(cat, :action => :update)) {
                                          cat.category_name
                                       }, 
                                       :entity => cat)
        list << HTML.li { cat }
      }
      body << list
      HTML.div.admin_category_box_body { body }
    end

    def admin_box
      box = Box.new(:type => :category_index, :class => :topic, :id => :admin_categories_box)
      box.header = tl(:categories)
      box.body   = admin_box_body()
      box
    end

    def show
      cat = load_instance()
      cat_id = cat.category_id

      users = cat.users
      elements = []
      if Aurita.user.is_registered? then
        users_box = Box.new(:type => :none, 
                            :class => :topic_inline)
        users_box.body = view_string(:user_list, :users => users)
        users_box.header = tl(:users)

        elements << users_box.string
      end
      components = plugin_get(Hook.main.category.list, :category_id => cat_id).collect { |c| c.string }
      elements += components

      Page.new(:header => cat.category_name) { elements }
    end

  end

end
end
