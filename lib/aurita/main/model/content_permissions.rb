
require('aurita/model')

Aurita::Main.import_model :user_group

module Aurita
module Main

  class Content_Permissions < Aurita::Model

    table :content_permissions, :public
    primary_key :content_permissions_id, :content_permissions_id_seq

    has_a User_Group, :user_group_id

  end

end
end
