
require('aurita/model')

Aurita::Main.import_model :user_login_data

module Aurita
module Main

  # Predefine
  class User_Online < Aurita::Model
  end

  class User_Profile < User_Login_Data
    extend Aurita::Taggable_Behaviour

    table :user_profile, :internal
    primary_key :user_group_id

    is_a User_Login_Data, :user_group_id

    expects :surname
    expects :tags

    def self.bootstrap
      create(:user_group_id => 1, 
             :user_group_name => 'admin', 
             :login => Digest::MD5.hexdigest('admin'), 
             :pass => Digest::MD5.hexdigest('admin'), 
             :tags => '{}')
      create(:user_group_id => 5, 
             :user_group_name => 'aurita', 
             :login => 'none', 
             :pass => 'none', 
             :tags => '{}')
    end

    def self.before_create(args)
      tags = args[:tags]
      tags.gsub!('{','')
      tags.gsub!('}','')
      tags.gsub!(',',' ')
      args[:tags] = "#{tags} #{args[:surname]} #{args[:forename]}"
      return args
    end
    
    add_output_filter(:tags) { |tags|
      if(tags && tags.instance_of?(String)) then
        tags = tags[1..-2].gsub(',',' ').gsub('\'','') if tags.length > 3
        tags.downcase
      else
        ''
      end
    }
    add_input_filter(:tags) { |tags|
      tags = tags.to_s
      tags.gsub!('{','')
      tags.gsub!('}','')
      tags.gsub!(',',' ')
      tags = tags.squeeze(' ')
      tags.gsub!(' ',',')
      tags.downcase!
      tags = '{' << tags + '}'
      tags
    }

  end

  class User_Group < Aurita::Model

    # Returns User_Profile instance of this user. 
    def profile
      @profile ||= User_Profile.find(1).with(User_Profile.user_group_id == user_group_id).entity 
      @profile
    end
  end

end
end
