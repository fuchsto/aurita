
require('aurita/plugin')

module Aurita
module Plugins
module Feed


  # Usage: 
  #
  #  Aurita::Main::plugin_get(Hook.right_column)
  #
  class Plugin < Aurita::Plugin::Manifest

    register_hook(:controller => Tag_Feed_Controller, 
                  :method     => :tag_feed_box, 
                  :hook       => Hook.my_place.left)
    register_hook(:controller => Feed_Collection_Controller, 
                  :method     => :toolbar_buttons, 
                  :hook       => Hook.main.toolbar)
                  
    register_hook(:controller => Cron_Controller, 
                  :method     => :clean_and_aggregate, 
                  :hook       => Hook.cron.hourly)
  end

end
end
end


