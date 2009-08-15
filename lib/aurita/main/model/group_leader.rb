
require('aurita/model')

module Aurita
module Main

  class Group_Leader < Aurita::Model
    
    table :group_leader, :internal
    primary_key :user_id
    primary_key :user_group_id

    aggregates User_Group, :user_id

    def self.is_group_leader(user_id, group_id) 
      return !(Group_Leader.select { |e|
        e.where(
          (Group_Leader.user_id == user_id) &
          (Group_Leader.user_group_id == group_id)
        )
      }.first.nil?)
    end

  end 

end # module
end # module
