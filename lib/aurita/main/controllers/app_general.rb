
require('aurita/controller')

Aurita::Main.import_model :hierarchy_entry
Aurita::Main.import_model :hierarchy
Aurita::Main.import_controller :app_main
Aurita::Main.import_controller :hierarchy
Aurita.import_module :gui, :user_icon

module Aurita
module Main

  class App_General_Controller < App_Controller

    def account_box
      account = Box.new(:type => :none, :class => :topic)
      account.header = tl(:account)
      if Aurita.user.is_registered? then
        logout_string = HTML.a(:href => "/aurita/App_Main/logout/x=#{rand(10000)}") { 
                          HTML.img(:src => '/aurita/images/icons/logout.gif') +  '&nbsp; Logout' 
                        }
        account.body = tl(:logged_in_as) + ' ' + link_to(:controller => 'User_Profile') { Aurita.user.user_group_name } + '<br /><br />' + logout_string
      else
        account.body = HTML.a(:class => :icon, :onclick => "Aurita.load({ action: 'App_Main/login/' })") { 
                         HTML.img(:src => "/aurita/images/icons/login.gif") + tl(:logon) 
                       }.string
      end
      return account
    end

    def left
      puts plugin_get(Hook.public.main.left.top).map { |component| component.string } 
      puts plugin_get(Hook.main.left.top).map { |component| component.string } 
      puts plugin_get(Hook.public.main.left).map { |component| component.string } 
      puts plugin_get(Hook.main.left).map { |component| component.string } 
      puts plugin_get(Hook.main.left.hierarchies, :perspective => 'GENERAL').map { |h| h.string } 
      exec_js("new accordion('app_left_column', { classNames: { content: 'accordion_box_body', toggle: 'accordion_box_header', toggleActive: 'accordion_box_header_active' } });");
    end

    def main 
      render_controller(App_Main_Controller, :start)
    end

    def users_online_box
      box = Box.new(:type => :none, :class => :topic, :id => :users_online_box)
      box.header = tl(:users_online)
      box.body = users_online_box_body
      box
    end

    def users_online_box_body
      body = HTML.ul(:class => :no_bullets)
      User_Online.current_users.each { |user|
        body << HTML.li { link_to(user) { "#{user.forename} #{user.surname}" } }
      }
      body
    end
    
  end # class
  
end # module
end # module

