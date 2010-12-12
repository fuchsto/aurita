

module Aurita

  module Plugin_Methods

    # Send a plugin hook signal that will not be answered with 
    # GUI components. An optinal parameter Hash can be passed. 
    #
    # Example: 
    #
    #   plugin_call(Hook.mail.after_send, [ :params => values ])
    #
    #
    def plugin_call(hook, call_params=nil)
      Aurita::Plugin_Register.call(hook, self, call_params)
    end
    # Send a plugin hook signal that will be answered with an 
    # array of GUI components. An optinal parameter Hash can be passed. 
    #
    # GUI components have to be derived from Aurita::GUI::Element. 
    #
    # Example: 
    #
    #   components = plugin_get(Hook.profile.left, [ :params => values ])
    #
    #
    def plugin_get(hook, call_params=nil)
      Aurita::Plugin_Register.get(hook, self, call_params)
    end

  end

end

