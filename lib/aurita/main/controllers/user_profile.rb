require('aurita/controller')
require('digest/md5')

Aurita::Main.import_model :user_profile
Aurita::Main.import_model :user_online
Aurita::Main.import_model :hierarchy
Aurita::Main.import_model :category
Aurita::Main.import_model :user_category
Aurita::Main.import_controller :app_main

module Aurita
module Main

  class User_Profile_Controller < App_Controller

#########################################
# BEGIN FORM CONFIG
#########################################
    
    guard_interface(:perform_update) { |c|
      (Aurita.user.is_admin? || c.param(:user_group_id).to_s == Aurita.user.user_group_id.to_s)
    }

    guard_interface(:perform_delete) { 
      Aurita.user.is_admin?
    } 

    def form_groups
      [
        User_Profile.picture_asset_id, 
        User_Profile.forename,
        User_Profile.surname,
        User_Profile.email_home, 
#       User_Profile.theme,
        User_Profile.tags, 
        User_Login_Data.pass, 
        'pass_confirm'
      ]
    end

    def form_groups_add
      [
        User_Group.user_group_name, 
        User_Profile.forename,
        User_Profile.surname, 
        User_Profile.tags, 
        User_Group.division,
        User_Login_Data.pass, 
        'pass_confirm'
      ]
    end

    def form_style_config
      { 
        :fav_clubs  => { :style_class => 'short_textarea' }, 
        :fav_bands  => { :style_class => 'short_textarea' }, 
        :fav_movies => { :style_class => 'short_textarea' }
      }
    end

    def custom_form_elements
      { 
        User_Profile.picture_asset_id.to_s => Aurita::GUI::Picture_Asset_Field
      }
    end

    def default_form_values
      { User_Profile.picture_asset_id.to_s => '1' }
    end
    
#########################################
# END FORM CONFIG
#########################################


    def add
      form = model_form(:model => User_Profile, :action => :register_user)
      form.fields  = form_groups_add()
      form[User_Profile.forename].required! 
      form[User_Profile.surname].required! 
      form[User_Profile.tags].required! 
      pass_confirm = Password_Field.new(:name => :pass_confirm, :label => tl(:confirm_password))
      form.add(pass_confirm)
      render_form(form)
    end

    def admin_add
      form = model_form(:model => User_Profile, :action => :perform_admin_add)
      form.fields  = form_groups_add()
      form[User_Profile.forename].required! 
      form[User_Profile.surname].required! 
      form[User_Profile.tags].required! 
      pass         = Password_Field.new(:name => :pass, :label => tl(:password))
      pass_confirm = Password_Field.new(:name => :pass_confirm, :label => tl(:confirm_password))
      form[User_Login_Data.pass] = pass
      form.add(pass_confirm)
      render_form(form, :title => tl(:add_user))
    end

    def perform_add
      expects(:user_group_name, :pass, :pass_confirm)

      param[:login]        = Digest::MD5.hexdigest(param(:user_group_name))
      pass                 = Digest::MD5.hexdigest(param(:pass))
      pass_confirm         = Digest::MD5.hexdigest(param(:pass_confirm))
      param[:pass]                = pass
      param[User_Login_Data.pass] = pass
      param[:pass_confirm]        = pass_confirm

      if(pass == pass_confirm) then
        instance = super()
        raise ::Exception.new('could not create user') unless instance

        # Create user's own content category: 
        user_cat = Category.create(:category_name => instance.user_group_name, :is_private => 't')
        # Assign user to its content category: 
        User_Category.create(:user_group_id => instance.user_group_id, 
                             :readonly      => 'f', 
                             :category_id   => user_cat.category_id)

        # Assign user to role "registered": 
        User_Role.create(:user_group_id => instance.user_group_id, 
                         :role_id => 1)

        return instance
      else
        notify_invalid_params(:pass_confirm => tl(:password_confirmation_mismatch))
      end
    end

    def register_user
      instance = perform_add()
      if instance then
        plugin_call(Hook.main.after_register_user, :user => instance) 
        App_Main_Controller.login() 
      end
    end

    def perform_admin_add
      instance = perform_add()
      if instance then
        plugin_call(Hook.main.after_register_user, :user => instance) 
        exec_js("Aurita.load({ element: 'admin_users_box_body', action: 'User_Profile/admin_box_body/' }); 
                 Aurita.load({ element: 'app_main_content', action: 'App_Main/blank/' }); ")
      end
    end

    def admin_box_body
      body = Array.new
      guest = Context_Menu_Element.new(HTML.a.entry(:onclick => js.Aurita.load(:action => 'User_Login_Data/update/user_group_id=0')) { tl(:unregistered_user) }, 
                                      :type => :system_link)
      body << HTML.button(:class => :icon, :onclick => js.Aurita.load(:action => 'User_Profile/admin_add/')) { 
        HTML.img(:src => '/aurita/images/icons/button_add.gif') + tl(:add_user) 
      }
      list = HTML.ul.single_line_list { HTML.li { guest } }
      User_Profile.all_with((User_Group.atomic == true) & (User_Login_Data.locked == 'f')).sort_by(:surname, :asc).each { |user|
        if user.user_group_id != '0' then
          user_label = user.surname.capitalize + ' ' + user.forename.capitalize 
          user_label << ' (' + user.division + ')' if user.division.to_s != ''
          user = Context_Menu_Element.new(HTML.a.entry(:onclick => js.Aurita.load(:action => "User_Login_Data/update/user_group_id=#{user.user_group_id}")) { 
                                            user_label
                                          }, 
                                          :entity => user) 
          list << HTML.li { user } 
        end
      }
      body << list
      HTML.div.admin_user_box_body { body } 
    end
    def admin_box
      box = Box.new(:type => :box, :class => :topic, :id => :admin_users_box)
      box.header = tl(:users)
      box.body   = admin_box_body()
      box
    end

    def show_own

      last_seen_online = User_Online.value_of.max(:time_from).where(User_Online.user_group_id == Aurita.user.user_group_id).to_s
      user = User_Group.load(:user_group_id => Aurita.user.user_group_id)
      user_profile = User_Profile.load(:user_group_id => Aurita.user.user_group_id)

      user_data_component = view_string(:user_profile_data, 
                                        :user => user, 
                                        :last_seen_online => last_seen_online, 
                                        :user_profile => user_profile) 
      components = [ Element.new(:content => user_data_component) ]
      components += plugin_get(Hook.main.user_own_profile.addons, 
                                        { :user => user, 
                                          :user_profile => user_profile }
                                       )
      render_view(:user_own_profile, 
                  :user => user, 
                  :user_profile => user_profile, 
                  :components => components)
    end

    def show(user=nil)
      return unless Aurita.user.is_registered? 
      
      if !user && !param(:user_group_id) then
        return show_own
      end

      user = load_instance() unless user

      if user.user_group_id == Aurita.user.user_group_id then
        return show_own
      end

      user_group_id = user.user_group_id
      if [0,5].include?(user_group_id.to_i) then
        puts 'Kein Profil'
        return
      end
      if user.locked == 't' then
        puts 'Benutzer wurde gesperrt'
        return
      end

      last_seen_online = User_Online.value_of.max(:time_from).where(User_Online.user_group_id == user_group_id).to_s
      user_profile = User_Profile.load(:user_group_id => user_group_id)

      user_data_component = view_string(:user_profile_data, 
                                        :user => user, 
                                        :last_seen_online => last_seen_online, 
                                        :user_profile => user_profile) 
      components = [ Element.new(:content => user_data_component) ]
      components += plugin_get(Hook.main.user_profile.addons, 
                                        { :user => user, 
                                          :user_profile => user_profile }
                                       )

      render_view(:user_profile, 
                  :user => user, 
                  :user_profile => user_profile, 
                  :components => components)

    end

    def show_by_username
      user = User_Profile.find(1).with(User_Group.user_group_name == param(:user_group_name)).entity
      puts 'Der Benutzer existiert nicht' unless user
      show(user) if user
    end

    def show_short
    end

    def update
      instance     = User_Profile.load(:user_group_id => param(:user_group_id))
      form         = update_form(User_Profile) 
      pass         = Password_Field.new(:name => User_Login_Data.pass, :label => tl(:change_password))
      pass_confirm = Password_Field.new(:name => :pass_confirm, :label => tl(:confirm_password))
      form.add(pass)
      form[User_Profile.theme] = Select_Field.new(:options => { :default => tl(:default_theme), :custom => tl(:custom_theme) }, 
                                                  :label => tl(:theme), 
                                                  :value => instance.theme, 
                                                  :name => User_Profile.theme.to_s)
      pass.value   = ''
      form.add(pass_confirm)
      form = decorate_form(form) 
      Page.new(:header => instance.user_group_name) { form }
    end

    def perform_update
      pass = param(:pass) # Save for later use
      @params[User_Login_Data.pass] = nil
      super()
      instance = load_instance()
      if(pass.nonempty? && pass == param(:pass_confirm)) then
        instance.pass = Digest::MD5.hexdigest(pass)
        instance.commit
      elsif (param(:pass) && param(:pass) != param(:pass_confirm)) then
        raise ::Exception.new('Passworte stimmen nicht &uuml;berein')
      end
      exec_js("Aurita.load({ element: 'admin_users_box_body', action: 'User_Profile/admin_box_body/' }); 
               Aurita.load({ element: 'app_main_content', action: 'User_Profile/show/user_group_id=#{instance.user_group_id}' }); ")
    end

    def perform_delete
      raise ::Exception.new('No. ')
    end
    
    def find_all(params)
      return unless params[:key]
      return unless Aurita.user.is_registered? 

      key = params[:key].to_s
      tags = key.split(' ')

      user_constraints = (User_Login_Data.locked == 'f')
      tags.each { |k|
        k << '%'
        user_constraints = user_constraints & 
                           ((User_Group.user_group_name.ilike('%' << k)) | 
                            (User_Profile.tags.has_element_ilike(k)))
      }
      users = User_Profile.all_with(user_constraints).sort_by(User_Profile.user_group_name, :asc).entities
      return unless users.first
      users_box = Box.new(:type => :none, 
                          :class => :topic_inline)
      users_box.body = view_string(:user_list, :users => users)
      users_box.header = tl(:users)
      return users_box
    end

  end

end
end
