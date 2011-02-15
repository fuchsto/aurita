
require('aurita/controller')
require('aurita-gui/javascript')
Aurita.import_module :gui, :context_menu
Aurita.import_module :gui, :helpers
Aurita.import_module :gui, :toggle_button
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
      log_params = []
      @params.each_pair { |k,v|
        if (k.to_s.first != '_') && 
            !([:controller, :dispatcher, :action, :element, :mode].include?(k.to_sym)) then
          log_params << "#{k}=#{v.to_s[0..50]}" if v.is_a?(Numeric) || v.is_a?(String)
        end
      }

      referer   = @params[:_request].env['HTTP_REFERER']
      remote_ip = @params[:_request].env['REMOTE_ADDR']
      remote_ip = false if remote_ip == '127.0.0.1' 
      
      # Proxy pass always leads to localhost as remote address. 
      remote_ip ||= @params[:_request].env['X-Real-IP'] 
      remote_ip ||= @params[:_request].env['HTTP_X_REAL_IP']
      host        = @params[:_request].env['HTTP_HOST']

      return if host.to_s.empty?
      return unless Aurita.project.domains && Aurita.project.domains.include?(host.to_s.split(':').first)

      referer   = '' if referer && host && referer.include?(host)

      User_Action.create(:controller    => params[:controller].class.to_s, 
                         :method        => params[:action], 
                         :params        => log_params.join('&'), 
                         :runmode       => Aurita.runmode.to_s.first, 
                         :user_group_id => Aurita.user.user_group_id, 
                         :session_id    => Aurita.session.session_id, 
                         :remote_ip     => remote_ip.to_s, 
                         :host          => host.to_s, 
                         :referer       => referer.to_s[0..254], 
                         :duration      => params[:time], 
                         :num_queries   => params[:num_queries], 
                         :num_tuples    => params[:num_tuples])

      log { "Queries: #{params[:num_queries]}, Tuples: #{params[:num_tuples]}, Time: #{params[:time]}" }
    end

    def ping
      puts 'AURITA ALIVE'
    end

    def blank
      puts '&nbsp;'
    end

    def login
      exec_js("$('login').focus(); "); 
      HTML.div { view_string(:login) }
    end

    def popup_box
      render_view(:popup_box, :action => param(:action))
    end
    def alert_box
      render_view(:alert_box, :message => param(:message))
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

      user_categories = Text_Button.new(:class  => :toolbar_button, 
                                        :icon   => :categories, 
                                        :action => 'User_Category/index') { 
          tl(:user_categories) 
      }

      components      = plugin_get(Hook.main.toolbar).map { |button| button.add_css_class(:toolbar_button); button }

      tool_box        = Box.new(:class => :topic, :id => 'toolbox', :type => :none)
      tool_box.header = tl(:tools)
      tool_box.body   = HTML.div.toolbar { [ user_categories ] + components } 

      result << tool_box

      return result
    end

    def header_buttons
      
      buttons  = Array.new
      buttons << Context_Menu_Element.new(HTML.div(:class => :header_button_active, 
                                                   :id => :button_App_General, 
                                                   :onclick => Javascript.Aurita.GUI.switch_layout('App_General')) { tl(:general) }, 
                                          :type   => :app_section,
                                          :params => { :category => 'GENERAL' } )

      if Aurita.user.is_registered? then
        buttons << Context_Menu_Element.new(HTML.div(:class => :header_button, 
                                                     :id => :button_App_My_Place, 
                                                     :onclick => Javascript.Aurita.GUI.switch_layout('App_My_Place')) { tl(:my_place) }, 
                                            :type   => :app_section, 
                                            :params => { :category => 'MY_PLACE' } )

      end
      plugin_buttons = plugin_get(Hook.main.tab_bar) 
      buttons += plugin_buttons

      if Aurita.user.is_admin? then
        buttons << Context_Menu_Element.new(HTML.div(:class => :header_button, 
                                                     :id => :button_App_Admin, 
                                                     :onclick => Javascript.Aurita.GUI.switch_layout('App_Admin')) { tl(:admin) }, 
                                            :type   => :app_section, 
                                            :params => { :category => 'ADMIN' } )
      end
      
      header = Element.new(:class => :header, :type => :header)
      header.content = buttons.join()
      return [ header ]

    end

    def start
      
      set_http_header('expires' => (Time.now-24*60*60).to_s)
      
      positions = Component_Position.select_values(:component_dom_id) { |i|
        i.where((Component_Position.user_group_id == Aurita.user.user_group_id) &
                (Component_Position.gui_context == 'workspace_components'))
        i.order_by(:position, :asc)
      }.flatten.map { |dom_id| "component_#{dom_id}" }
      log { "Positions are: #{positions.inspect}" } 

      # Maps dom_id to their components
      components = {}
      sorted     = []
      plugin_get(Hook.main.workspace.top).each { |component|
        component.sortable = true if component.respond_to?(:sortable) 
        dom_id = 'component_' << component.dom_id.to_s
        sorted << dom_id 
        components[dom_id] = HTML.li(:id => dom_id) { component }
      }
      plugin_get(Hook.main.workspace).each { |component|
        component.sortable = true if component.respond_to?(:sortable) 
        dom_id = 'component_' << component.dom_id.to_s
        sorted << dom_id 
        components[dom_id] = HTML.li(:id => dom_id) { component }
      }

      if positions.length == 0 then
        positions = sorted
      end

      result = []
      positions.each { |dom_id|
        result << components[dom_id]
      }
      
      exec_js("Aurita.GUI.init_sortable_components('workspace_components', { handle: 'box_sort_handle' } ); ")
      exec_js("Aurita.GUI.init_sortable_components('recent_category_changes', { handle: 'box_sort_handle' } ); ")
      exec_js("Aurita.GUI.collapse_boxes(); ")
      
      HTML.ul(:id => :workspace_components, :class => :no_bullets ) { result }
    end

    def frontpage
      components = plugin_get(Hook.main.workspace.frontpage)
      components ||= []
      return components
    end

    def recent_changes_in_categories
      count      = 0
      result     = HTML.ul(:class => :no_bullets, :id => :recent_category_changes) { } 
      # Load GUI component positions: 
      positions  = Component_Position.select_values(:component_dom_id) { |i|
        i.where((Component_Position.user_group_id == Aurita.user.user_group_id) &
                (Component_Position.gui_context == 'recent_category_changes'))
        i.order_by(:position, :asc)
      }.flatten.map { |dom_id| dom_id.split('_').last.to_i }

      filtered_cat_ids = Category_Feed_Filter.find(1).with(:user_group_id => Aurita.user.user_group_id).entity
      filtered_cat_ids = filtered_cat_ids.category_ids if filtered_cat_ids

      # Map categories to Hash, so we can iterate over positions
      categories = {}
      Aurita.user.readable_categories.each { |c|
        categories[c.category_id] = c
      }
      positions ||= categories.keys
      # If there aren't any user defined positions, default them to 
      # their natural order: 
      if positions.length == 0 then
        positions = categories.keys
      elsif positions.length < categories.keys.length then
        # Add category ids not mapped to a position
        positions += categories.keys - positions
      end
      
      positions -= filtered_cat_ids if filtered_cat_ids

      positions.each { |cat_id|
        cat_result = ''
        cat = categories[cat_id]
        if cat then
          components = plugin_get(Hook.main.workspace.recent_changes_in_category, :category_id => cat_id)
          components.each { |component|
            cat_result << HTML.span(:id => 'component_' << count.to_s) { component.string }.string
            count += 1
          }
          if components.length > 0 then
            box = Box.new(:type     => :category, 
                          :class    => :topic_inline, 
                          :sortable => true, 
                          :id       => "category_#{cat_id}", 
                          :params   => { :category_id => cat_id } )
            box.header = tl(:category) + ' ' << cat.category_name 
            box.body = cat_result
            result << HTML.li(:id => "component_category_box_#{cat_id}") { box.string }.string
            count += 1
          end
        end
      }
      return unless count > 0

      exec_js("Aurita.GUI.init_sortable_components('workspace_components', { handle: 'box_sort_handle' } ); ")
      exec_js("Aurita.GUI.init_sortable_components('recent_category_changes', { handle: 'box_sort_handle' } ); ")
      exec_js("Aurita.GUI.collapse_boxes(); ")
      
      return result
    end

    def recent_changes

      viewmode_btn  = GUI::Toggle_Button.new(:id => :recent_changes_viewmode_button)
      viewmode_btn.add_mode(:categories, { :action  => 'App_Main/recent_changes_in_categories', 
                                           :element => :recent_changes_page_content,
                                           :icon    => 'category_view.png' }) # category_view.png
      viewmode_btn.add_mode(:timeline, { :action  => 'Content_History/list_body', 
                                         :element => :recent_changes_page_content,
                                         :icon    => 'clock.png' }) # clock.png
      viewmode_btn.active_mode = :categories
      
      page = Page.new(:header   => tl(:recent_changes), 
                      :sortable => true, 
                      :tools    => viewmode_btn, 
                      :id       => :recent_changes_page) { recent_changes_in_categories } 
      return page
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

      set_http_header('expires' => (Time.now-24*60*60).to_s)

      Aurita.session.close()
      Aurita.session = false

      http_redirect_to('/')
    end

    def my_profile
      User_Profile_Controller.show_own
    end

    def find_all
      components = plugin_get(Hook.main.find_all, :key => param(:key))
      components = [ HTML.div { tl(:no_results) } ] if components.first.nil? 

      Page.new(:header => tl(:all_search_results)) { 
        components.map { |c| c.string }.join('')
      }
    end
    alias find find_all

    def find_full
      components = plugin_get(Hook.main.find_full, :key => param(:key))
      components = [ HTML.div { tl(:no_results) } ] if components.first.nil? 

      Page.new(:header => tl(:fulltext_search_results)) { 
        components.map { |c| c.string }.join('')
      }
    end

  end # class
  
end # module
end # module

