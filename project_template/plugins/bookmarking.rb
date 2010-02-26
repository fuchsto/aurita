
require('aurita/plugin')

module Aurita
module Plugins
module Bookmarking


  # Usage: 
  #
  #  Aurita::Main::plugin_get(Hook.right_column)
  #
  class Plugin < Aurita::Plugin::Manifest

    register_hook(:controller => Bookmark_Controller, 
                  :method     => :find, 
                  :hook       => Hook.main.find)

    register_hook(:controller => Bookmark_Controller, 
                  :method     => :url_bookmark_box, 
                  :hook       => Hook.my_place.left)

    register_hook(:controller => Bookmark_Controller, 
                  :method     => :article_bookmark_box, 
                  :hook       => Hook.my_place.left)

    register_hook(:controller => Bookmark_Controller, 
                  :method     => :media_bookmark_box, 
                  :hook       => Hook.my_place.left)

    register_hook(:controller => Autocomplete_Controller, 
                  :method     => :find_bookmarks, 
                  :hook       => Hook.main.autocomplete_search.all)
                  
  end

end
end
end


