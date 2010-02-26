
require('aurita/plugin')

module Aurita
module Plugins
module Calendar

  class Plugin < Aurita::Plugin::Manifest

    register_hook(:controller => Calendar_Controller, 
                  :method     => :calendar_box, 
                  :hook       => Hook.main.left)
    register_hook(:controller => Event_Controller, 
                  :method     => :upcoming_events, 
                  :hook       => Hook.main.workspace.top)
                  
  end

end
end
end


