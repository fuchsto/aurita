
require('aurita/controller')
Aurita.import_module :gui, :custom_form_elements

module Aurita
module Main

  class Category_Controller < App_Controller

    guard(:CUD) { |controller_instance|
      Aurita.user.is_admin? 
    }
    
    def form_groups
      [
       Category.category_name, 
       :read_access, 
       :write_access
      ]
    end

    after(:perform_update, :perform_delete) { |c|
      c.redirect_to(:controller => 'App_Main', :action => :blank)
      c.redirect(:element => :admin_categories_box_body, :to => :admin_box_body)
    }

    private

    def resolve_access
      case param(:read_access)
      when 'public' then
        set_params(:public_readable     => true, 
                   :registered_readable => false)
      when 'registered' then
        set_params(:public_readable     => false, 
                   :registered_readable => true)
      else
        set_params(:public_readable     => false, 
                   :registered_readable => false)
      end

      case param(:write_access)
      when 'public' then
        set_params(:public_writeable     => true, 
                   :registered_writeable => false)
      when 'registered' then
        set_params(:public_writeable     => false, 
                   :registered_writeable => true)
      else
        set_params(:public_writeable     => false, 
                   :registered_writeable => false)
      end
    end

    public

    def add
      form = add_form
      form.add(GUI::Category_Access_Options_Field.new(:label => tl(:read_access), 
                                                      :name  => :read_access))
      form.add(GUI::Category_Access_Options_Field.new(:label => tl(:write_access), 
                                                      :name  => :write_access))
      
      Page.new(:header => tl(:add_category)) { decorate_form(form) }
    end

    def update
      category     = load_instance()
      category_id  = category.category_id
      components   = plugin_get(Hook.admin.category.show, :category_id => param(:category_id))
      update_form  = update_form() 
      write_access = :members
      write_access = :public if category.public_writeable
      write_access = :registered if category.registered_writeable
      read_access  = :members
      read_access  = :public if category.public_readable
      read_access  = :registered if category.registered_readable
      update_form.add(GUI::Category_Access_Options_Field.new(:label => tl(:read_access), 
                                                             :value => read_access, 
                                                             :name  => :read_access))
      update_form.add(GUI::Category_Access_Options_Field.new(:label => tl(:write_access), 
                                                             :value => write_access, 
                                                             :name  => :write_access))
      form = view_string(:admin_edit_category, 
                         :update_form         => decorate_form(update_form).string, 
                         :category            => Category.load(:category_id => category_id), 
                         :category_users      => User_Category_Controller.user_list(category_id), 
                         :category_components => components)
      page = Page.new(:header => tl(:edit_category)) { form }
      page.add_css_class(:form_section)
      page
    end 

    def perform_delete
      new_cat_id   = param(:new_category_id)
      new_cat_id ||= 1
      # Reassign contents, but do not create duplicate assignments: 
      if new_cat_id != 1 then
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
      else
        Content_Category.update { |cc|
          cc.set(:category_id => new_cat_id)
          cc.where((Content_Category.category_id == param(:category_id)) & 
                   (Content_Category.content_id.not_in( 
                      Content_Category.select(:content_id) { |cid|
                        cid.where(Content_Category.category_id != param(:category_id))
                      })
                   )
                  )
        }
      end

      Content_Category.delete { |cc|
        cc.where(Content_Category.category_id == param(:category_id))
      }
      User_Category.delete { |cc|
        cc.where(User_Category.category_id == param(:category_id))
      }
      Hierarchy_Category.delete { |cc|
        cc.where(Hierarchy_Category.category_id == param(:category_id))
      }
      super()
    end

    def perform_add

      check = Category.find(1).with(Category.category_name.ilike("#{param(:category_name)}")).entity
      if check then
        exec_js(js.alert(tl(:category_name_already_used)))
        return
      end

      resolve_access()
      instance = super()

      redirect(:element => :admin_categories_box_body, :to => :admin_box_body)
      redirect_to(instance, :action => :update)
    end

    def perform_update
      resolve_access()
      super()
      redirect_to(:blank)
    end

    def toggle_versioned
      category = load_instance()
      if category.versioned then
        category.versioned = false 
      else
        category.versioned = true 
      end
      category.commit
      redirect_to(category, :action => :update)
    end

    def admin_box_body
      body = Array.new
      body << HTML.a(:class   => :icon, 
                     :onclick => link_to(:add)) { 
        icon_tag(:categories) + tl(:add_content_category) 
      } 
      list = HTML.ul.no_bullets { } 
      Category.all_with((Category.is_private == 'f') & 
                        (Category.category_id >= '100')).sort_by(:category_name, :asc).each { |cat|
        cat = Context_Menu_Element.new(HTML.a.entry(:onclick => link_to(cat, :action => :update)) {
                                          cat.category_name
                                       }, 
                                       :entity => cat)
        list << HTML.li { cat }
      }
      body << list
      HTML.div.scrollbox { body }
    end

    def admin_box
      box        = Box.new(:type  => :category_index, 
                           :class => :topic, 
                           :id    => :admin_categories_box)
      box.header = tl(:categories_box_header)
      box.body   = admin_box_body()
      box
    end

    def show
      cat    = load_instance()
      cat_id = cat.category_id

      return unless Aurita.user.readable_category_ids.include?(cat_id)

      users = cat.users
      implicit_users = false
      if cat.registered_readable then
        implicit_users = User_Profile.all_with((User_Profile.user_group_id > 100) & 
                                               (User_Profile.locked == 'f')).sort_by(:surname, :asc).entities 
      end
      elements = []
      if Aurita.user.is_registered? then
        if users && users.length > 0 then
          users_box = Box.new(:type  => :none, 
                              :class => :topic_inline)
          users_box.body   = view_string(:user_list, :users => users)
          users_box.header = tl(:category_members)
          
          elements << users_box.string
        end

        if implicit_users then
          impl_users_box = Box.new(:type      => :none, 
                                   :class     => :topic_inline)
          impl_users_box.collapsed = true
          impl_users_box.body   = view_string(:user_compact_list, 
                                              :users  => implicit_users)
          impl_users_box.header = tl(:users_with_read_access)
          elements << impl_users_box.string
        end
      end
      components = plugin_get(Hook.main.category.list, :category_id => cat_id).collect { |c| c.string }
      elements += components

      Page.new(:header => cat.category_name) { elements }
    end

  end

end
end
