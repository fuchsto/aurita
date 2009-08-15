
require('aurita/model')
Aurita::Main.import_model :user_group

module Aurita
module Main

  class User_Group < Aurita::Model
  end

  class User_Group_Hierarchy < Aurita::Model
    
    table :user_group_hierarchy, :internal
    primary_key :user_group_id__parent
    primary_key :user_group_id__child
  # aggregates User_Group, :user_group_id__child <-- post-defined in User_Group model

    def self.get_parent_group_ids(user_group_id, group_arr=Array.new)
      
      User_Group_Hierarchy.select  { |e| 
        e.where(User_Group_Hierarchy.user_group_id__parent == user_group_id)
      }.each { |entry|
        group_arr.push(entry.attr[:user_group_id__parent])
        group_arr = get_parent_groups(entry.attr[:user_group_id], group_arr)
      }
      return group_arr
      
    end
    
  end

end # module
end # module

  
