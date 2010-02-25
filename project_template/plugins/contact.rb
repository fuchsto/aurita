
require('aurita/plugin')

module Aurita
module Plugins
module Contact

  class Plugin < Aurita::Plugin::Manifest

    register_hook(:controller => Contact_Person_Controller, 
                  :method     => :contact_box, 
                  :hook       => Hook.main.left)
                  
    register_hook(:controller => Autocomplete_Controller, 
                  :method     => :find_contacts, 
                  :hook       => Hook.main.autocomplete_search.all)
  end

end
end
end


