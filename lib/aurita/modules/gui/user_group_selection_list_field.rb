
require('aurita')
require('aurita-gui')
require('aurita-gui/widget')

Aurita.import_module :gui, :i18n_helpers


module Aurita
module GUI

  # Specialization of Aurita::GUI::Selection_List_Field:
  # Sets
  #   options: All available non-atomic user groups
  #   value: Array of user group ids currently assigned to user
  # Expects: 
  #   user: Instance of user to create selection list for
  #
  class User_Group_Selection_List_Field < Selection_List_Field
  include Aurita::GUI::I18N_Helpers

    attr_accessor :user

    class User_Group_Selection_List_Option_Field < Selection_List_Option_Field
    include Aurita::GUI::I18N_Helpers

      def initialize(params={})
        super(params)
        @user = @parent.user
      end
      def element
        HTML.div { 
          HTML.a(:class => :icon, 
                 :onclick => "Aurita.call({ onload: function() { Aurita.load({ element: 'user_groups_list', 
                                                                               action: 'User_Group/group_list/user_group_id=#{@user.user_group_id}' }); }, 
                                            action: 'User_Group_Hierarchy/perform_delete/user_group_id=#{@user.user_group_id}&category_id=#{@value}' });") { 
            HTML.img(:src => '/aurita/images/icons/delete_small.png') 
          } + 
          @label.to_s 
        }
      end
    end

    def initialize(params={})
      @user         = params[:user]
      active_groups = @user.parent_groups.map { |g| g.user_group_id }
      options       = []
      group_ids     = []
      params.delete(:user)
      
      @select_field_name = params[:name] # Otherwise '_select' would be appended to name of select field

      User_Group.all_with(User_Group.atomic == false).sort_by(User_Group.user_group_name).each { |c|
        STDERR.puts c.inspect
        options << c.user_group_name
        group_ids << c.user_group_id
      }
      options.fields = group_ids.map { |v| v.to_s }
   
      super(params)
      set_options(options) 
      set_value(active_groups)

      @option_field_decorator = User_Group_Selection_List_Option_Field
    end

  end # class

end
end
