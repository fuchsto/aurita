
require('aurita')
require('aurita-gui')
require('aurita-gui/widget')

Aurita.import_module :gui, :i18n_helpers


module Aurita
module GUI
  
  # Specialisation of Aurita::GUI::Selection_List_Field:
  # Sets
  #   options: All available roles
  #   value: Array of role ids currently assigned to user
  # Expects: 
  #   user: Instance of user to create selection list for
  #
  class User_Role_Selection_List_Field < Selection_List_Field
  include Aurita::GUI::I18N_Helpers

    attr_accessor :user, :select_field_name

    class User_Role_Selection_List_Option_Field < Selection_List_Option_Field
      def initialize(params={})
        @user = params[:parent].user
        super(params)
      end
      def element
        HTML.div { 
          HTML.a(:class => :icon, 
                 :onclick => "Aurita.call({ action: 'User_Role/perform_delete/user_group_id=#{@user.user_group_id}&role_id=#{@value}' });") { 
            HTML.img(:src => '/aurita/images/icons/delete_small.png') 
          } + 
          @label.to_s
        }
      end
    end

    def initialize(params={})
      @select_field_name = params[:name] # Otherwise '_select' would be appended to name of select field
      
      @user = params[:user]
      params.delete(:user)
      active_roles = user.immediate_role_ids
      options = {}
      Role.find(:all).sort_by(Role.role_name).each { |c|
        options[c.role_id] = c.role_name
      }
      super(params)
      set_options(options)
      set_value(active_roles)
      @option_field_decorator = User_Role_Selection_List_Option_Field
    end
  end

end
end

