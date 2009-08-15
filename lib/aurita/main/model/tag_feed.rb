
require('aurita/model')
Aurita::Main.import_model :user_group

module Aurita
module Main

  class Tag_Feed < Aurita::Model

    table :tag_feed, :public
    primary_key :tag_feed_id, :tag_feed_id_seq
    
    has_a User_Group, :user_group_id

#   validates :tags, { :format => /^\{([\.a-zA-Z_0-9-\s,])+\}$/, :mandatory => true }

    add_input_filter(:tags) { |tags| 
      tags = '{' << tags.gsub(',',' ').squeeze(' ').gsub(' ',',') << '}' 
      tags.gsub('{{','{').gsub('}}','}')
    }
    add_output_filter(:tags) { |tags| 
      tags.gsub('{','').gsub('}','').gsub(',',' ').squeeze(' ')
    }

  end 

end # module
end # module
