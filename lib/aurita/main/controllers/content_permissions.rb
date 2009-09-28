
require('aurita/controller')

module Aurita
module Main 

  class Content_Permissions_Controller < App_Controller
    guard_interface(:perform_add, :perform_update, :perform_delete) { |c|
      Aurita.user.may_edit_content?(c.param(:content_id))
    }

    def perform_add
      Content_Permissions.delete { |cp| 
        cp.where(Content_Permissions.content_id == param(:content_id))
      }
      param(:user_group_ids).each { |uid| 
        readonly = 'f'
        if param('readonly_' << uid) then 
          readonly = 't'
        end
        Content_Permissions.create(:content_id    => param(:content_id), 
                                   :user_group_id => uid, 
                                   :readonly      => readonly) 
      } if param(:user_group_ids)
    end

    def editor
      content = Content.load(:content_id => param(:content_id))
      
      options = {}
      permissions = Content_Permissions.select { |cp| 
        cp.join(User_Group).using(:user_group_id) { |ucp|
          ucp.where(Content_Permissions.content_id == param(:content_id))
          ucp.order_by(:content_permissions_id)
        }
      }.each { |p|
        options[p.user_group_id] = p.user_group_name
      }
      content = Content.load(:content_id => param(:content_id))
      
      user_select = User_Selection_List_Field.new(:name => :user_group_ids)
      user_select.options = options
      user_select.value   = options.keys
      
      render_view(:content_permissions_editor, 
                  :content => content, 
                  :content_type => param(:type), 
                  :username_autocompleter => user_select)
      
      exec_js("Aurita.Main.init_autocomplete_single_username();")
    end

  end

end
end
