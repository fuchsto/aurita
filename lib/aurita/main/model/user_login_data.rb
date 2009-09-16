
require('aurita/model')
Aurita::Main.import_model :user_group

module Aurita
module Main

  # Extends model User_Group by login credentials (encrypted 
  # user_group_name and password)
  class User_Login_Data < User_Group
    
    table :user_login_data, :internal
    primary_key :user_group_id, User_Group.user_group_id
  
    is_a User_Group, :user_group_id

    expects :login
    expects :pass

    # Returns instance of User_Login_Data (being an instance of User_Group) 
    # by login credentials. 
    def self.resolve_user(login_md5, pass_md5)
      return find(1).with((User_Login_Data.login == login_md5) & (User_Login_Data.pass == pass_md5)).entity
    end
    
  end

end # module
end # module
