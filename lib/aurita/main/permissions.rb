
require('aurita/plugin')

module Aurita
module Main

  class Permissions < Aurita::Plugin::Manifest

    register_permission(:delete_hierarchies, 
                        :type    => :bool, 
                        :default => true)

  end

end
end

