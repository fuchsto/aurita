
require('aurita/controller')
Aurita::Main.import_controller :user_profile

module Aurita
module Main

  class User_Group_Controller < App_Controller

    guard(:CRUD) { |c| Aurita.user.is_admin? }

    def form_groups
      [
       User_Group.user_group_name
      ]
    end

    def add_group
      form = add_form
      form.fields = [
         User_Group.user_group_name, 
         User_Group.atomic
      ]
      form.add(Text_Field.new(:name => User_Group.user_group_name, 
                              :label => tl(:user_group_name)))
      form.add(Hidden_Field.new(:name => User_Group.atomic, 
                                :value => 'f'))

      Page.new(:header => tl(:add_user_group)) { 
        decorate_form(form)
      }
    end

    def update_group
      group = User_Group.load(:user_group_id => param(:user_group_id))
       
      form = view_string(:admin_edit_user_group, 
                         :user_categories => User_Category_Controller.category_list(group.user_group_id),
                         :user_roles      => User_Role_Controller.list_string(group.user_group_id),
                         :group           => group)
      page = Page.new(:header => tl(:edit_user)) { form }
      page.add_css_class(:form_section) 
      return page

      form = update_form
      form.fields = [
         User_Group.user_group_name, 
         User_Group.atomic
      ]
      form.add(Text_Field.new(:name => User_Group.user_group_name, 
                              :label => tl(:user_group_name)))
      form.add(Hidden_Field.new(:name => User_Group.atomic, 
                                :value => 'f'))

      Page.new(:header => tl(:edit_user_group)) { 
        decorate_form(form) + 
        HTML.br + 
        Text_Button.new(:onclick => link_to(:delete_group, :user_group_id => load_instance().user_group_id), 
                        :icon    => 'button_cancel.gif') { tl(:delete_user_group) }
      }
    end

    def delete_group
      form = delete_form
      form.add(Text_Field.new(:name => User_Group.user_group_name, 
                              :label => tl(:user_group_name)))
      form.readonly! 
      Page.new(:header => tl(:delete_user_group)) { 
        decorate_form(form) 
      }
    end

    def is_registered
      puts '0' unless Aurita.user.is_registered?
      puts '1' if !Aurita.user.is_admin? and Aurita.user.is_registered?
      puts '2' if Aurita.user.is_admin? 
    end

    def username_available
      puts User_Group.find(1).with(User_Group.user_group_name.ilike(param(:user_group_name))).entity.nil?.to_s
    end
    

    def perform_delete
      if !load_instance().atomic then
        redirect(:element => :admin_user_groups_box_body, :to => :admin_box_body)
        redirect_to(:blank)
      end
      super()
    end

    def perform_update
      if !load_instance().atomic then
        redirect(:element => :admin_user_groups_box_body, :to => :admin_box_body)
        redirect_to(:blank)
      end
      super()
    end

    def perform_add
      @params[:atomic] = 't' unless param(:atomic)
      if param(:atomic) == 'f' then
        redirect(:element => :admin_user_groups_box_body, :to => :admin_box_body)
        redirect_to(:blank)
      end
      super()
    end

    def show
      render_controller(User_Profile_Controller, :show, :user_group_id => id())
    end

    def group_list(user_group_id=nil)
      user_group_id ||= param(:user_group_id)
      user = User_Group.load(:user_group_id => user_group_id)
      HTML.div { view_string(:admin_user_groups_list, 
                             :user => user) }
    end

    def admin_box_body
      body   = Array.new
      groups = User_Group.all_with(User_Group.atomic == false).sort_by(:user_group_name, :asc).to_a
      list   = HTML.ul.no_bullets { } 
      groups.map { |g|
        entry = HTML.div { 
          link_to(g, :action => :update_group) { g.user_group_name } 
        }
        list << HTML.li { Context_Menu_Element.new(:entity => g) { entry } }
      }
      body << list
      HTML.div { body }
    end
    def admin_box
      box         = Box.new(:header => tl(:user_groups), 
                            :id     => :admin_user_groups_box, :class => :topic)
      box.body    = admin_box_body()
      box.toolbar = [ 
        Toolbar_Button.new(:icon   => :add_user_group, 
                           :action => 'User_Group/add_group') { 
          tl(:add_user_group)
        }
      ]
      box
    end
    
  end

end
end
