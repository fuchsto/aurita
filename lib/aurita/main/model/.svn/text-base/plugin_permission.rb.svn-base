
require('aurita/model')

module Aurita
module Main

  class Plugin_Permission < Aurita::Model
    table :plugin_permission, :internal
    primary_key :plugin_permission_id, :plugin_permission_id_seq

  end

  class Role_Permission < Aurita::Model
    def self.check_permission(user_group_id, perm)
      permission = super(user_group_id, perm)
      return permission if permission

    end
  end

end
end
