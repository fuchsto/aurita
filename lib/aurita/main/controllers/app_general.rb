
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
      account        = Box.new(:type => :none, :class => :topic, :id => :account_box )
      account.header = tl(:account)
      if Aurita.user.is_registered? then
        logout  = Toolbar_Button.new(:icon   => :logout, 
                                     :link   => '/aurita/App_Main/logout') { tl(:logout) }
        profile = Toolbar_Button.new(:icon   => :user, 
                                     :action => 'User_Profile/show_own') { Aurita.user.user_group_name } 
        account.body = profile + logout
      else
        logon   = Toolbar_Button.new(:icon    => :login, 
                                     :onclick => "Aurita.load({ action: 'App_Main/login/' });") { tl(:logon) }
        account.body = logon
      end
      return account
    end

    def left
      plugin_get(Hook.public.main.left.top).each { |component| render(component) } 
      plugin_get(Hook.main.left.top).each { |component| render(component) } 
      plugin_get(Hook.public.main.left).each { |component| render(component) } 
      plugin_get(Hook.main.left).each { |component| render(component) } 
      plugin_get(Hook.main.left.hierarchies, :perspective => 'GENERAL').each { |h| render(h) } 
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
        body << HTML.li { link_to(user) { user.label } } unless ([0,100].include? user.user_group_id)
      }
      body
    end

  end # class
  
end # module
end # module

