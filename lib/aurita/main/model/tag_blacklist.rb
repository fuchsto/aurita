
require('aurita/model')

module Aurita
module Main

  class Tag_Blacklist < Aurita::Model

    table :tag_blacklist, :public
    primary_key :tag
    
  end 

end # module
end # module
