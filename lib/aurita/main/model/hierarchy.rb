
require('aurita/model')

module Aurita
module Main

  class Hierarchy < Aurita::Model

    table :hierarchy, :public
    primary_key :hierarchy_id, :hierarchy_id_seq

    use_label :header

    hide_attribute :category

    validates :header, :maxlength => 23, :mandatory => true

  end 

end # module
end # module
