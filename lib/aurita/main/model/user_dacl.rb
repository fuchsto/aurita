
require('aurita/model')

module Aurita
module Main

  class User_DACL < Aurita::Model
    table :user_dacl, :public
    primary_key :user_dacl_id, :user_dacl_id_seq

  end

end
end

