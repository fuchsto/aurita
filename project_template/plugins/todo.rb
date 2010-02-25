
require('aurita/plugin')

module Aurita
module Plugins
module Todo

  class Plugin < Aurita::Plugin::Manifest

#   register_hook(:controller => Todo_Container_Asset_Controller, 
#                 :method     => :container_type, 
#                 :hook       => Hook.wiki.container.types)

    register_hook(:controller => Todo_Asset_Controller, 
                  :method     => :toolbar_buttons, 
                  :hook       => Hook.main.toolbar)

    register_hook(:controller => Todo_Entry_Controller, 
                  :method     => :latest_profile_box, 
                  :hook       => Hook.main.user_own_profile.addons)
    register_hook(:controller => Todo_Asset_Controller, 
                  :method     => :find_full, 
                  :hook       => Hook.main.find_full)
    register_hook(:controller => Todo_Asset_Controller, 
                  :method     => :find, 
                  :hook       => Hook.main.find)

    register_hook(:controller => Todo_Entry_Controller, 
                  :method     => :latest_box, 
                  :hook       => Hook.main.workspace.top)

    register_hook(:controller => Autocomplete_Controller, 
                  :method     => :find_todos, 
                  :hook       => Hook.main.autocomplete_search.all)

  end

end
end
end
