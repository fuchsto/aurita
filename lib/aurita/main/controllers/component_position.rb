
require('aurita/controller')
Aurita::Main.import_model :component_position

module Aurita
module Main

  class Component_Position_Controller < App_Controller

    guard(:add, :perform_add, :delete, :perform_delete, :update, :show) { 
      false
    }

    def perform_update
      Component_Position.delete { |c|
        c.where((c.user_group_id == Aurita.user.user_group_id) &
                (c.gui_context == param(:context)))
      }
      context = param(:context).to_sym
      param(context, []).each_with_index { |c,idx|
        Component_Position.create(:position         => idx, 
                                  :gui_context      => param(:context), 
                                  :user_group_id    => Aurita.user.user_group_id, 
                                  :component_dom_id => c)
      }
    end
    alias set perform_update

  end

end
end

