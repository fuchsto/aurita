
require('aurita/model')
Aurita::Main.import_model :user_profile

module Aurita
module Main

  class User_Online < Aurita::Model

    table :user_online, :public
    primary_key :user_group_id
    primary_key :session_id
    
    # Return list of users currently online as unsorted Array. 
    def self.current_users
      reg   = {}
      users = []
      User_Profile.select { |s|
        s.join(User_Action).using(:user_group_id) { |u| 
          u.where((User_Action.time > Time.now() - 5.minutes) & 
                  (User_Action.user_group_id <=> 0))
        }
      }.each { |u|
        if !reg[u.user_group_id] then
          reg[u.user_group_id] = true
          users << u
        end
      }
      users
    end
    
    # Return last time this user has logged in, as unprocessed String
    def self.last_login_time(user_group_id)
      select_value(:time_to) { |u| 
        u.where((u.time_to.is_not_null) & (u.user_group_id == user_group_id))
        u.order_by(u.time_to, :desc)
        u.limit(1)
      }['time_to']
    end

  end

  class User_Group < Aurita::Model

    # Shortcut for 
    #   User_Online.last_login_time(user_group_id)
    def last_login_time
      User_Online.last_login_time(user_group_id)
    end
  end

end
end

