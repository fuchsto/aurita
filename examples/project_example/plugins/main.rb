
require('aurita/plugin')

module Aurita
module Plugins
module Main

  class Plugin < Aurita::Plugin::Manifest

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


  end

end
end
end


