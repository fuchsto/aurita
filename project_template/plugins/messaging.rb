
require('aurita/plugin')

module Aurita
module Plugins
module Messaging

  class Plugin < Aurita::Plugin::Manifest

    register_hook(:controller => Mailbox_Controller, 
                  :method     => :toolbar_buttons, 
                  :hook       => Hook.main.toolbar)
    register_hook(:controller => User_Message_Controller, 
                  :method     => :unread_mail_box, 
                  :hook       => Hook.main.workspace.top)
    register_hook(:controller => User_Message_Controller, 
                  :method     => :poll_unread_mail, 
                  :hook       => Hook.main.poll_feedback)
                  
  end

end
end
end


