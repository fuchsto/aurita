
require('aurita/plugin')

module Aurita
module Main

  class Permissions < Aurita::Plugin::Manifest

    register_permission(:delete_hierarchies, 
                        :type    => :bool, 
                        :default => true)

    register_permission(:edit_hierarchies, 
                        :type    => :bool, 
                        :default => true)
    
    register_permission(:view_recent_comments, 
                        :type    => :bool, 
                        :default => true)

  end

end
end

