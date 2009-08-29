require('aurita/controller')
require('aurita-gui/javascript')
Aurita.import_module :gui, :context_menu
Aurita.import_module :gui, :helpers
Aurita::Main.import_model :hierarchy_entry
Aurita::Main.import_model :hierarchy
Aurita::Main.import_model :user_online
Aurita::Main.import_model :role_permission
Aurita::Main.import_model :user_profile
Aurita::Main.import_model :user_online
Aurita::Main.import_controller :user_profile
Aurita::Main.import_controller :hierarchy_entry
Aurita::Main.import_controller :app_general

module Aurita
module Main

  class App_Main_Controller < App_Controller
    include Aurita::GUI

    guard_interface(:admin_box) { 
      Aurita.user.is_admin?
    }

    def on_request_finish(params={})
    # return if params[:controller].is_a?(Aurita::Main::Async_Feedback_Controller)

      User_Action.create(:controller => params[:controller].class.to_s, 
                         :method => params[:action], 
                         :user_group_id => Aurita.user.user_group_id, 
                         :duration => params[:time], 
                         :num_queries => params[:num_queries], 
                         :num_tuples => params[:num_tuples])
      log { "Queries: #{params[:num_queries]}, Tuples: #{params[:num_tuples]}, Time: #{params[:time]}" }
    end

    def ping
      puts 'AURITA ALIVE'
    end

    def blank
      puts '&nbsp;'
    end

    
    def login
      exec_js("Effect.Appear('login_box', { afterFinish: function() { $('login').focus(); } }); ")
      render_view(:login)
    end

    def popup_box
      render_view(:popup_box, :action =>  param(:action))
    end
    def alert_box
      render_view(:alert_box, :message =>  param(:message))
    end
    def confirmation_box
      render_view(:confirmation_box, :message => param(:message))
    end

    def latest_users(amount)
      users = User_Profile.find(amount).with(User_Profile.user_group_id <=> '0').sort_by(:time_registered, :desc).entities
      box = Box.new(:type => :none, :class => :topic)
      box.header = tl(:latest_users)
      body = view_string(:user_thumbnail, :users => users)
      box.body = body << '<div style="clear: both;" ></div>'
      box.string
    end

    def autocomplete
      Element.new { view_string(:autocomplete) }
    end

    def system_box
      result = []

      user_categories = HTML.a(:class => :icon, 
                               :onclick => "Cuba.load({ action: 'User_Category/index'});") { 
          icon_tag(:categories) +
          tl(:user_categories) 
      }

      components = plugin_get(Hook.main.toolbar)
      tool_box = Box.new(:class => :topic, :id => 'toolbox', :type => :none)
      tool_box.header = tl(:tools)
      tool_box.body = [ user_categories ] + components

      result << tool_box

      if Aurita.user.is_admin? then
        admin_components = plugin_get(Hook.main.admin_toolbar)
        admin_tool_box = Box.new(:class => :topic, :id => 'admin_toolbox')
        admin_tool_box.header = tl(:admin_tools)
        admin_tool_box.body = admin_components
        result << admin_tool_box
      end
      
      return result
    end

    def header_buttons()
      
      buttons  = Array.new
      buttons << Context_Menu_Element.new(HTML.div(:class => :header_button_active, 
                                                   :id => :button_App_General, 
                                                   :onclick => Javascript.app_load_setup('App_General')) { tl(:general) }, 
                                          :type => :site_general,
                                          :params => { :category => 'GENERAL' } )

      if Aurita.user.is_registered? then
        buttons << Context_Menu_Element.new(HTML.div(:class => :header_button, 
                                                     :id => :button_App_My_Place, 
                                                     :onclick => Javascript.app_load_setup('App_My_Place')) { tl(:my_place) }, 
                                            :type => :site_my_place, 
                                            :params => { :category => 'MY_PLACE' } )

      end
      plugin_buttons = plugin_get(Hook.main.tab_bar) 
      buttons += plugin_buttons

      if Aurita.user.is_admin? then
        buttons << Context_Menu_Element.new(HTML.div(:class => :header_button, 
                                                     :id => :button_App_Admin, 
                                                     :onclick => Javascript.app_load_setup('App_Admin')) { tl(:admin) }, 
                                            :type => :site_app_admin, 
                                            :params => { :category => 'ADMIN' } )
      end
      
      header = Element.new(:class => :header, :type => :header)
      header.content = buttons.join()
      return [ header ]

    end

    def start
    # set_http_header('Cache-Control' => 'no-cache, must-revalidate');
    # set_http_header('Pragma' => 'no-cache');
    # @request.out('Cache-Control' => 'no-store, no-cache, must-revalidate, post-check=0,pre-check=0')
      
      set_http_header('expires' => Time.now-24*60*60)

      result = ''
      count = 0
      plugin_get(Hook.main.workspace.top).each { |component|
        result << HTML.li(:id => 'component_' << count.to_s) { component.string }.string
        count += 1
      }
      plugin_get(Hook.main.workspace).each { |component|
        result << HTML.span(:id => 'component_' << count.to_s) { component }.string
        count += 1
      }
      puts HTML.ul(:id => 'workspace_components', :class => 'no_bullets' ) { result }.string
      exec_js("Effect.Appear('app_main_content'); ")
    end

    def frontpage
      components = plugin_get(Hook.main.workspace.frontpage)
      components ||= []
      return components
    end

    def recent_changes
      count = 0
      result = HTML.ul.no_bullets { } 
      Aurita.user.categories.each { |cat| 
        cat_result = ''
        components = plugin_get(Hook.main.workspace.recent_changes_in_category, :category_id => cat.category_id)
        components.each { |component|
          cat_result << HTML.span(:id => 'component_' << count.to_s) { component.string }.string
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
          result << HTML.li(:id => 'component_' << count.to_s) { box.string }.string
          count += 1
        end
      }
      return unless count > 0
      return Page.new(:header => tl(:recent_changes)) { result } 
    end

    def tag_index
      view_string(:tag_index, :tags => Tag_Index.all.entities)
    end

    # Performs logon for user upon validating credentials. 
    # Expects parameters 'login' and 'pass' as MD5, 
    # returns JSON string containing session id created for 
    # this user, like: 
    #
    #   { 'session_id': '32jgdx94l34dkjg6743545kjfsdlkjr3' }
    #
    def validate_user
      use_decorator(:none)

      log('Login validation')
      user_string = param(:login).to_s
      pass_string = param(:pass).to_s

      user = User_Login_Data.resolve_user(user_string, pass_string)
      
      if user then
        log { "Login accepted: #{user.user_group_id}" }
        Aurita.session.open(user)
        sid = Aurita.session.session_id
        puts "({'session_id': '#{sid}'})"
      else
        puts '0'
      end
      
    end
    
    def logout
      use_decorator(:blank)
      set_http_header('expires' => Time.now-24*60*60)

      log('logout user')
      Aurita.session.close()

      render_view(:after_logout)
    end

    def my_profile
      User_Profile_Controller.show_own
    end

    def find_all
      components = plugin_get(Hook.main.find_all, :key => param(:key))
      render_view(:find_all, 
                  :components => components)

    end
    alias find find_all

    def find_full
      components = plugin_get(Hook.main.find_full, :key => param(:key))
      render_view(:find_full, 
                  :components => components)

    end

  end # class
  
end # module
end # module

