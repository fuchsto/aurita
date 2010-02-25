
require('aurita/plugin')
Aurita::Project.import_controller :app_main
Aurita::Project.import_controller :hierarchy

module Aurita
module Plugins
module Main

  # Usage: 
  #
  #  Aurita::Main::plugin_get(Hook.right_column)
  #
  class Plugin < Aurita::Plugin::Manifest

    register_hook(:controller => Aurita::Default::App_Main_Controller, 
                  :method     => :on_request_finish, 
                  :hook       => Hook.dispatcher.request_finished)

    register_hook(:controller => Aurita::Default::App_Main_Controller, 
                  :method     => :header_buttons, 
                  :hook       => Hook.public.main.head)
    register_hook(:controller => App_Main_Controller, 
                  :method     => :system_box, 
                  :hook       => Hook.main.left.top)
    register_hook(:controller => Aurita::Main::Hierarchy_Controller, 
                  :method     => :list, 
                  :hook       => Hook.main.left.hierarchies)
    register_hook(:controller => Aurita::Main::App_General_Controller, 
                  :method     => :account_box, 
                  :hook       => Hook.public.main.right)
    register_hook(:controller => Aurita::Main::App_Main_Controller, 
                  :method     => :autocomplete, 
                  :hook       => Hook.public.main.right.top)
    register_hook(:controller => Aurita::Main::App_General_Controller, 
                  :method     => :users_online_box, 
                  :hook       => Hook.main.right) { Aurita.user.is_registered? }

    register_hook(:controller => Aurita::Main::Content_Comment_Controller, 
                  :method     => :recent_comments_box, 
                  :hook       => Hook.main.workspace.top) { Aurita.user.is_registered? }

    register_hook(:controller => Aurita::Main::App_Main_Controller, 
                  :method     => :recent_changes, 
                  :hook       => Hook.main.workspace)

# Admin area
   
    register_hook(:controller => Aurita::Main::App_Admin_Controller, 
                  :method     => :system_box, 
                  :hook       => Hook.admin.left.top)

    register_hook(:controller => Aurita::Main::User_Profile_Controller, 
                  :method     => :admin_box, 
                  :hook       => Hook.admin.left)
    register_hook(:controller => Aurita::Main::App_Admin_Controller, 
                  :method     => :locked_users_box, 
                  :hook       => Hook.admin.left)
    register_hook(:controller => Aurita::Main::Role_Controller, 
                  :method     => :admin_box, 
                  :hook       => Hook.admin.left)
    register_hook(:controller => Aurita::Main::Category_Controller, 
                  :method     => :admin_box, 
                  :hook       => Hook.admin.left)

    register_hook(:controller => Aurita::Default::App_Main_Controller, 
                  :method     => :header_buttons, 
                  :hook       => Hook.public.my_place.head)

# My Place

    register_hook(:controller => App_Main_Controller, 
                  :method     => :system_box, 
                  :hook       => Hook.my_place.left.top)
    register_hook(:controller => Aurita::Main::Hierarchy_Controller, 
                  :method     => :list, 
                  :hook       => Hook.my_place.left.hierarchies)

    register_hook(:controller => Aurita::Main::Autocomplete_Controller, 
                  :method     => :find_users, 
                  :hook       => Hook.main.autocomplete_search.all)

# Public theme
    
    register_hook(:controller => Aurita::Default::Hierarchy_Controller, 
                  :method     => :list, 
                  :hook       => Hook.theme.public.right)

  end

end
end
end


