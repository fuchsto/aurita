
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

    def immediate_roles()
    # {{{
      Role.select { |r|
        r.join(User_Role).using(:role_id) { |ur|
          ur.where(User_Role.user_group_id == user_group_id)   
        }
      }.to_a
    end # def }}}
    alias own_roles immediate_roles

    # Get roles of User_Group instance as array of 
    # Table_Accessor instances of User_Role. 
    def roles() 
    # {{{
      if !@roles then
        inherited_roles = Array.new
        parent_groups.each { |g|
          inherited_roles += g.immediate_roles
        } 
        own = immediate_roles()
        if own then
          @roles = own + inherited_roles
        else 
          @roles = inherited_roles
        end
      end
      @roles
    end # def }}}

    def immediate_role_ids()
    # {{{
      User_Role.select_values(:role_id) { |r|
        r.where(User_Role.user_group_id == user_group_id)   
      }.to_a.flatten.map { |r| r.to_i }
    end # def }}}
    alias own_role_ids immediate_role_ids

    def role_ids()
    # {{{
      if !@role_ids then
        inherited_role_ids = Array.new
        parent_groups.each { |g|
          inherited_role_ids += g.immediate_role_ids
        } 
        own = immediate_role_ids()
        if own then
          @role_ids = own + inherited_role_ids
        else 
          @role_ids = inherited_role_ids
        end
      end
      @role_ids
    end # def }}}
  end

end # module
end # module

# Post-include User_Group: 
Aurita::Main.import_model :user_group
