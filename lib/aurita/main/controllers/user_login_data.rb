
require('aurita/controller')

module Aurita
module Main

  class User_Login_Data_Controller < App_Controller
    
    guard_interface(:update, :perform_lock, :perform_unlock, :perform_delete, :perform_add) { 
      Aurita.user.is_admin?
    }
    
    def perform_add
      instance = super()
      cat = Category.create(:category_name => instance.user_group_name)
    end
    
    def form_groups
      [
       User_Group.user_group_name, 
       User_Login_Data.login, 
       User_Login_Data.pass
      ]
    end
    
    def update
      user = User_Profile.load(:user_group_id => param(:user_group_id))
       
      form = view_string(:admin_edit_user, 
                         :user_categories => User_Category_Controller.category_list(user.user_group_id),
                         :user_roles      => User_Role_Controller.list_string(user.user_group_id),
                         :user_groups     => User_Group_Controller.group_list(user.user_group_id),
                         :user            => user)
      page = Page.new(:header => tl(:edit_user)) { form }
      page.add_css_class(:form_section) 
      page
    end
    
    def show
      render_controller(User_Group_Controller, :show)
    end

    # To be called as admin user only
    def perform_update
      return unless Aurita.user.is_admin? 

      instance = load_instance
    
      login = param(:login).gsub("\s",'')
      pass  = param(:pass)
      exec_js(js.Aurita.flash(tl(:no_login_specified))) if login.to_s == ''

      login_md5 = Digest::MD5.hexdigest(login) if param(:login).to_s.gsub(/\s/,'') != ''
      login_md5 = instance.login unless login_md5
      pass_md5 = Digest::MD5.hexdigest(pass) if param(:pass).to_s.gsub(/\s/,'') != ''
      pass_md5 = instance.pass unless pass_md5

      # Check if selected login is still available
      check = User_Group.find(1).with((User_Group.user_group_name.ilike(login)) & 
                                      (User_Group.user_group_id <=> param(:user_group_id))).entity
      exec_js(js.Aurita.flash(tl(:login_already_used))) if check

      @params[:pass] = pass_md5
      @params[:login] = login_md5
      @params[:user_group_name] = login

      user = User_Profile.load(:user_group_id => instance.user_group_id)
      user.forename = param(:forename)
      user.surname = param(:surname)
      user.division = param(:division)
      user.tags = param(:tags)
      user.commit

      super()
      redirect_to(:blank)
      redirect(:target => :admin_users_box_body, :controller => 'User_Profile', :action => :admin_box_body)
    end

    def perform_lock
      instance = load_instance
      instance.locked = true
      instance.commit
      redirect_to(instance, :action => :update)
    end
    def perform_unlock
      instance = load_instance
      instance.locked = false
      instance.commit
      redirect_to(instance, :action => :update)
    end

    def delete
      puts HTML.h2.critical { tl(:delete_user) }
      form = delete_form
      form.fields = [ User_Group.user_group_name ]
      render_form(form)
    end
    
    def perform_delete
      instance         = load_instance
      instance.locked  = true; 
      instance.deleted = true; 
      instance.hidden  = true; 
      instance.user_group_name = "#{instance.user_group_name} (X) #{instance.user_group_id}"
      instance.login   = "deleted #{instance.user_group_id}"
      instance.pass    = "deleted #{instance.user_group_id}"
      instance.commit
      redirect_to(:controller => 'App_Main', :action => :blank)
      redirect(:target => :admin_users_box_body, :controller => 'User_Profile', :action => :admin_box_body)
    end

  end

end
end
