
require('aurita/model')

module Aurita
module Main 

  class Tag_Synonym < Aurita::Model
		table :tag_synonym, :public
    primary_key :tag
    primary_key :synonym
	end

end
end
