
require('aurita/model')
Aurita::Main.import_model :user_group_hierarchy
Aurita::Main.import_model :user_role

module Aurita
module Main

  # Base class for every user type within the application. 
  # This also covers virtual users, system users and the like. 
  # 
  # A User_Group can either be atomic (regular user) or contain 
  # other User_Group instances. 
  #
  # Virtual users appear as regular users but are in fact a group 
  # of several users. 
  # This is needed for external interfaces (like email), when a 
  # single user is adressed but messages are delivered to several 
  # users. 
  #
  # Thus, there is no specific model for regular users, which is 
  # uncommon. 
  # This is necessary and comfortable however, as virtual users 
  # are displayed as regular users, but handled a group of users 
  # internally. 
  #
  # Associated models within Aurita::Main are: 
  # - User_Group_Hierarchy, implementing non-atomic user groups. 
  # - User_Login_Data, containing credentials needed for authentification. 
  # - User_Profile, containing profile information for regular users. 
  #
  # - User_Category, mapping Category instances to users. 
  # - User_Role, mapping Role instances to users. 
  # - User_Action, for logging single user actions. 
  # - User_Online, for logging when a user was active and whether 
  #   a user is online
  #
  class User_Group < Aurita::Model
    
    table :user_group, :internal
    primary_key :user_group_id, :user_group_id_seq

    expects :user_group_name
    use_label :user_group_name

    hide_attribute :atomic

    # Renders user name to string. 
    def label
      return "#{user_group_name} (#{division})" if division && !division.empty? 
      return user_group_name.to_s
    end
    alias label_string label

 private
    # Filter user group hierarchy using a visitor. 
    # Visitor is expected to offer a boolean method 
    # 'match' that decides whether or not a User_Group 
    # entry has to be filtered or not. 
    def visit(visitor, result=Array.new, level=0)
    # {{{
      if visitor.match(self) then
        result += self
        
        my_children_groups = User_Group_Hierarchy.select { |g|
          g.where(g['node_id__parent'] == attr['user_group_id'])
        }
        
        my_children_groups.each { |g|
          g.visit(visitor, result, level+1)
        }
        return result
        
      end
      return nil
    end # }}}
  
    def visit_depth_first(visitor, result=Array.new, level=0)
    # {{{
      my_children_groups = self.select { |g|
        g.where(g['node_id__parent'] == attr['node_id'])
      }
      
      continue = false
      children_result = Array.new
    
      my_children_groups.each { |g|
        child_result = g.visit_depth_first(visitor, result, level+1)
        if !child_result.nil? then
          continue = true
          children_result += child_result
        end
      }
      if continue then
        result += self
        result += children_result
        return result
      else
        return nil
      end
    end # }}}
    
    
    # Whether group is atomic (i.e. an user) or not
    # @tested
    def is_atomic?
      attr['atomic'] == 't'
    end

  public 

    def immediate_roles()
    # {{{
        own_roles = User_Role.select { |r|
          r.where(r[User_Role.user_group_id] == attr['user_group_id'])   
        }
    end # def }}}
    
    # Get roles of User_Group instance as array of 
    # Table_Accessor instances of User_Role. 
    def roles() 
    # {{{
        inherited_roles = Array.new
        get_groups.each { |g|
          inherited_roles += g.immediate_roles
        } unless get_groups.nil?
        own = own_roles()
        if own then
          return own + inherited_roles
        else 
          return inherited_roles
        end
        
    end # def }}}

    def get_own_users(user_group_id=nil) 
    # {{{
        
      own_users = User_Group_Hierarchy.select { |e| 
        e.where(
          (e['user_group_id__parent'] == user_group_id)
        )
      }
      return own_users

    end # def }}}
    # Query all users that belong to this group, directly or via
    # hierarchy. 
    # @tested
    def get_users(user_group_id=nil) 
    # {{{
      users = Array.new
      if is_atomic? then return nil end
      if user_group_id.nil? then 
        user_group_id = attr['user_group_id'] 
      end
      
      own_users = User_Group_Hierarchy.select { |e| 
        e.where(
          (e['user_group_id__parent'] == user_group_id)
        )
        e.order_by('user_group_name', :asc)
      }.each { |ugh|
        user = User_Group.select { |ug|
                ug.where(ug['user_group_id'] == ugh.attr['user_group_id__child'])
                ug.order_by('user_group_name', :asc)
        }.first
        if user.is_atomic? then users.push(user) 
        else
          users += get_users(ugh.attr['user_group_id__child'])
        end
      }
  
      return users
      
    end # def }}}

    # Query all groups this group is part of, directly or via 
    # hierarchy. 
    def get_groups(user_group_id=nil) 
    # {{{

      groups = Array.new
      
      if user_group_id.nil? then 
        user_group_id = attr['user_group_id'] 
      end
      
      parents = User_Group_Hierarchy.select { |e| 
        e.where(User_Group_Hierarchy.user_group_id__child == user_group_id)
        e.order_by('user_group_name', :asc)
      }

      parents.each { |entry|
        if entry.attr['user_group_id__parent'] >= '300' then
          group = User_Group.select { |ug|
            ug.where(
              ug['user_group_id'] == entry.attr['user_group_id__parent']
            )
            ug.order_by('user_group_name', :asc)
            ug.limit(1)
          }.first
          if !group.nil? && !group.is_atomic? then groups.push(group) end
        else 
          return []
        end
        child_groups = get_groups(entry.attr['user_group_id__parent'])
        groups += child_groups unless child_groups.nil?
      }
      return groups
      
    end # def }}}
    
  end # class 

  # Post-define aggregation in User_Role: 
  class User_Role < Aurita::Model
    aggregates User_Group, :user_group_id
  end

  class User_Group_Hierarchy < Aurita::Model
    aggregates User_Group, :user_group_id__child
  end
  
end # module
end # module
