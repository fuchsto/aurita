
require('aurita/controller')
Aurita::Main.import_controller :user_profile

module Aurita
module Main

  class User_Group_Controller < App_Controller

    def form_groups
      [
       User_Group.user_group_name
      ]
    end

    def is_registered
      puts '0' unless Aurita.user.is_registered?
      puts '1' if !Aurita.user.is_admin? and Aurita.user.is_registered?
      puts '2' if Aurita.user.is_admin? 
    end

    def username_available
      puts User_Group.find(1).with(User_Group.user_group_name.ilike(param(:user_group_name))).entity.nil?.to_s
    end
    

    def perform_delete
      raise ::Exception.new('Not authorized') unless Aurita.user.is_admin?
      super()
    end

    def perform_update
      raise ::Exception.new('Not authorized') unless Aurita.user.is_admin?
      super()
    end

    def perform_add
      raise ::Exception.new('Not authorized') unless Aurita.user.is_admin?

      @params[:atomic] = 't'
      super()
    end

    def show
      render_controller(User_Profile_Controller, :show, :user_group_id => id())
    end
    
  end

end
end
