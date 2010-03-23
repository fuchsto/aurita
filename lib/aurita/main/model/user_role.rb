
require('aurita/model')
Aurita::Main.import_model :role
# POST-INCLUDED: Aurita::Main.import_model :user_group

module Aurita
module Main

  class User_Role < Aurita::Model
    
    table :user_role, :internal
    primary_key :role_id
    primary_key :user_group_id

  end # class

  class User_Group < Aurita::Model

    # Return roles this user is member of, as unsorted array. 
    def roles
      if !@roles then
        STDERR.puts '-- ROLES ---------------------------------------------------'
        @roles = Role.select { |r|
          r.join(User_Role).using(:role_id) { |ur|
            ur.where(User_Role.user_group_id == user_group_id)
          }
        }.to_a
        STDERR.puts '-- END ROLES ---------------------------------------------------'
      end
      return @roles
    end
    
    # Return ids of roles this user is member of, as unsorted array. 
    def role_ids
      if !@role_ids then
        @role_ids = User_Role.select_values(User_Role.role_id) { |rid|
          rid.where(User_Role.user_group_id == user_group_id)
        }.to_a.flatten.map { |i| i.to_i }
      end
      return @role_ids
    end
  end

end # module
end # module

# Post-include User_Group: 
Aurita::Main.import_model :user_group
