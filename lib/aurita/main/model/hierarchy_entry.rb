
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

    def allow_access?(user)
      return true if entry_type == 'FILTER'
      return true if entry_type == 'BLANK_NODE'
      return Aurita.user.may_view_content?(content_id) if content_id
    end
    
  end 

end # module
end # module
