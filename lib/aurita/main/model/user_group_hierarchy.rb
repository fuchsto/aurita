
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

  class User_Group < Aurita::Model

    def add_member(user)
      User_Group_Hierarchy.create(:user_group_id__parent => user_group_id, 
                                  :user_group_id__child  => user.user_group_id)
    end
    alias add_group add_member

    def user_group_id_stack
      @user_group_id_stack ||= ([ user_group_id ] + user_group_id_stack_rec(user_group_id))
      @user_group_id_stack
    end

  private

    def user_group_id_stack_rec(child_uid)
      parent_uids = User_Group_Hierarchy.select_values(:user_group_id__parent) { |puid|
        puid.where(:user_group_id__child => child_uid)
      }.to_a.flatten.map { |puid| puid.to_i }
      next_parent_uids = []
      parent_uids.each { |puid|
        next_parent_uids += user_group_id_stack_rec(puid)
      }

      return (parent_uids + next_parent_uids).uniq
    end
    
  end

end # module
end # module

  
