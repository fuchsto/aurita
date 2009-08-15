
require('aurita/model')
Aurita::Main.import_model :content
Aurita::Main.import_model :user_group

module Aurita
module Main

  class Content_History < Aurita::Model

    table :content_history, :public
    primary_key :content_history_id, :content_history_id_seq
    
    has_a Content, :content_id
    has_a User_Group, :user_group_id

  end 

end # module
end # module
