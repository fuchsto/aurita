
require('aurita/plugin')

module Aurita
module Main


  # Usage: 
  #
  #  plugin_get(Hook.right_column)
  #
  class Permissions < Aurita::Plugin::Manifest

    register_permission(:view_recent_comments, 
                        :type    => :bool, 
                        :default => true)
  end

end
end

