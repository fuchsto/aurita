
require('aurita/model')

module Aurita
module Main

  class Hierarchy < Aurita::Model
  include Aurita::Access_Strategy

    table :hierarchy, :public
    primary_key :hierarchy_id, :hierarchy_id_seq

    use_label :header

    hide_attribute :category

    validates :header, :maxlength => 23, :mandatory => true

    def entries
      Hierarchy_Entry.all_with(:hierarchy_id => hierarchy_id).sort_by(:sortpos, :asc).to_a
    end

  end 

end # module
end # module
