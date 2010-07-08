
require('aurita/controller')

module Aurita
module Main

  class User_Group_Hierarchy_Controller < App_Controller

    guard(:CRUD) { Aurita.user.is_admin? } 

    def perform_add
      param[:user_group_id__child]    = param(:user_group_id)
      param[:user_group_id__parent]   = param(:group_id)
      param[:user_group_id__parent] ||= param(:group_id_select)
      super()
    end

    def perform_delete
      param[:user_group_id__child]    = param(:user_group_id)
      param[:user_group_id__parent]   = param(:group_id)
      param[:user_group_id__parent] ||= param(:group_id_select)
      super()
    end

  end

end
end

