
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

    def root_entries
      Hierarchy_Entry.all_with(:hierarchy_id => hierarchy_id, :hierarchy_entry_id_parent => 0).sort_by(:sortpos, :asc).to_a
    end

    def concrete_entries
      # TODO: Use this as a test case for Lore. 
      # Does not yet work as expected, as result 
      # entities are not extended by Hierarchy_Entry 
      # attributes correctly. Join works/ though. 
      #
      Content.polymorphic_select { |c|
        c.join(Hierarchy_Entry).using(:content_id) { |he|
          he.where(:hierarchy_id => hierarchy_id)
          he.order_by(:sortpos, :asc)
        }
      }.to_a.flatten
    end

  end 

end # module
end # module
