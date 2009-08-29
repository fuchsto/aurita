
require('aurita/controller')
# Cuba.import_imp_model :wiki, :article

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
      exec_js("Cuba.load({ element: 'admin_categories_box_body', action: 'Category/admin_box_body/' }); 
               Cuba.load({ element: 'app_main_content', action: 'App_Main/blank/' }); ")
    end
    
    def perform_add

      check = Category.find(1).with(Category.category_name.ilike("%#{param(:category_name)}%")).entity
      if check then
        exec_js(js.alert(tl(:category_name_already_used)))
        return
      end

      instance = super()
      redirect_to(:controller => 'Category', :action => :show, :category_id => instance.category_id)
      exec_js("Cuba.load({ element: 'admin_categories_box_body', action: 'Category/admin_box_body/' }); 
               Cuba.load({ element: 'app_main_content', action: 'App_Main/blank/' }); ")
    end

    def perform_update
      super()
      exec_js("Cuba.load({ element: 'admin_categories_box_body', action: 'Category/admin_box_body/' }); 
               Cuba.load({ element: 'app_main_content', action: 'App_Main/blank/' }); ")
    end

    def admin_box_body
      body = Array.new
      body << HTML.button(:class => :icon, :onclick => js.Cuba.load(:action => 'Category/add/')) { 
        HTML.img(:src => '/aurita/images/icons/button_add.gif') + tl(:add_content_category) 
      }
      list = HTML.ul.single_line_list { } 
      Category.all_with((Category.is_private == 'f') & (Category.category_id >= '100')).sort_by(:category_name, :asc).each { |cat|
        cat = Context_Menu_Element.new(HTML.a.entry(:onclick => js.Cuba.load(:action => "Category/update/category_id=#{cat.category_id}")) { 
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
      
    def self.defunct_form_field(args={})

      content      = args[:for]
      content    ||= args[:content]
      field_name   = args[:name]
      field_name ||= Category.category_id

      user_category = Aurita.user.category
      category_options = { user_category.category_id => tl(:your_category) + ' (' << user_category.category_name + ')' }
      
      cat_filter = false
      if Aurita.user.is_admin? then 
        cat_filter = Category.is_private == 'f' 
      else
        cat_filter = (Category.category_id.in(Aurita.user.category_ids) & (Category.is_private == 'f'))
      end

      Category.select { |c| 
        c.where(cat_filter)
        c.order_by(:category_name, :asc)
      }.each { |c|
        category_options[c.category_id] = c.category_name
      }

      if Aurita.user.is_admin? then 
        Category.select { |c| 
          c.where(Category.is_private == 't')
          c.order_by(:category_name, :asc)
        }.each { |c|
          if c.category_id != user_category.category_id then
            category_options[c.category_id] = tl(:user) + ': ' << c.category_name
          end
        }
      end

      if content && content.category then
        selected_cat_id = content.category_id
      else
        selected_cat_id = category_ids.first
      end
      if Aurita.user.is_admin? or category_ids.include?(content.category_id) then
        return Select_Field.new(:name => field_name, 
                                :label => tl(:category), 
                                :options => category_options, 
                                :value => selected_cat_id)
      else
        return Hidden_Field.new(:name => field_name, 
                                :value => content.category_id)
      end
    end

    def show
    
      cat = load_instance()
      cat_id = cat.category_id

      cache_name = Aurita.project_path + "cache/category_#{cat_id}.html"
      if(!File.exists?(cache_name)) then
        # TODO: Add this as a test case: 
        #    users = User_Category.select { |uc|
        #      uc.join(User_Profile).on(User_Category.user_group_id == User_Profile.user_group_id) { |up|
        #        up.where(uc.category_id == cat_id) 
        #        up.order_by(:user_group_name, :asc)
        #      }
        #    }
        users = User_Profile.select { |uc|
          uc.where(User_Profile.user_group_id.in( User_Category.select(User_Category.user_group_id) { |uid| 
            uid.where(User_Category.category_id == cat_id) 
          } ))
          uc.order_by(:user_group_name, :asc)
        }

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

        contents = Page.new(:header => cat.category_name) { elements }
        begin
          File.delete(cache_name) 
        rescue ::Exception => e
        end
        File.open(cache_name, "a") { |f|
          f << contents
        }
      end

      File.open(cache_name, "r") { |f|
        f.each { |l| 
          puts l
        }
      }

    end

    def recent_changes_string(cat) 
      cat_result = ''
      result = HTML.ul
      cache_name = Aurita.project_path + "cache/category_changes_#{cat.category_id}.html"

      count = 0
      if(!File.exists?(cache_name)) then
        cat_result = ''
        components = plugin_get(Hook.main.workspace.recent_changes_in_category, :category_id => cat.category_id)
        components.each { |component|
          cat_result << HTML.span(:id => 'component_' << count.to_s) { component }.string
          count += 1
        }
        if components.length > 0 then
          cat_id = cat.category_id
          box = Box.new(:type => :category, 
                        :class => :topic_inline, 
                        :id => 'category_' << cat_id, 
                        :params => { :category_id => cat_id } )
          box.header = tl(:category) + ' ' << cat.category_name 
          box.body = cat_result
          result << HTML.li(:id => 'component_' << count.to_s) { box }
          count += 1
        end
        File.open(cache_name, "a") { |f|
          f << result.string
        }
      end

      string = ''
      File.open(cache_name, "r") { |f|
        f.each { |l| 
          string << l
        }
      }
      string
    end

  end

end
end
