
require('aurita/model')
Aurita::Main.import_model :hierarchy

module Aurita
module Main

  class Hierarchy_Entry < Aurita::Model

    table :hierarchy_entry, :public
    primary_key :hierarchy_entry_id, :hierarchy_entry_id_seq
    
    belongs_to Hierarchy, :hierarchy_id

    has_a Hierarchy_Entry, :parent_entry, :hierarchy_entry_id_parent
    hide_attribute :hierarchy_entry_id_parent
    
    use_label :label

    validates :label, :maxlength => 100
    expects :label

    explicit :content_id

    def pkey_value
      hierarchy_entry_id
    end

    def parent_id
      hierarchy_entry_id_parent
    end
    
    def has_children?
      Hierarchy_Entry.find(1).with(Hierarchy_Entry.hierarchy_entry_id_parent == hierarchy_entry_id).entity
    end

    def children
      Hierarchy_Entry.select { |e|
        e.where(Hierarchy_Entry.hierarchy_entry_id_parent == hierarchy_entry_id)
        e.order_by(:sortpos, :asc)
      }
    end
    
    def concrete_instance
      Content.select { |c|
        c.join(Hierarchy_Entry).using(:content_id) { |he|
          he.where(:hierarchy_entry_id => hierarchy_entry_id)
          he.limit(1)
        }
      }.to_a.first.concrete_instance
    end

    def allow_access?(user)
      return Aurita.user.may_view_content?(content_id) if content_id
      return true
    end

    def hierarchy
      Hierarchy.get(hierarchy_id)
    end

    def position
      sortpos
    end
    
  end 

end # module
end # module
