
require 'aurita'
Aurita.import :base, :plugin_register
Aurita.import_module :permission
  
module Aurita::Plugin

# A plugin is an observer implementation. 
# The main app sends signals on every defined event, such as 
# 'User has been added', 'File has been deleted' ect. 
# Every controller dispatch resolves to a signal and thus 
# can be fetched by any plugin. 
#
class Manifest

  # Returns name of this plugin, determined by namespace 
  # it is using, as downcased symbol. 
  # Example: 
  #
  #    Aurita::Plugins::Wiki::Manifest.plugin_name   --> :wiki
  #
  def self.plugin_name
    self.to_s.split('::')[-2].downcase.to_sym
  end

  # Connect controller methods in this plugin with 
  # hooks emitted in the application. 
  # An optional block can be passed that supresses the
  # plugin response when returning false. 
  #
  # Example: 
  # Method My_Plugin_Controller.left_column will only be 
  # called in case a user is registered. 
  #
  #   register_hook(Hook.main.column.left, 
  #                 :controller => My_Plugin_Controller, 
  #                 :method => :left_column) { 
  #     Aurita.user.is_registered?
  #   }
  #
  # See also: Plugin_Register
  #
  def self.register_hook(params, &block)
    params[:plugin] = self
    params[:constraint] = block if block_given? 
    Plugin_Register.add(params)
  end

  # Plugins may use their own permission sets. 
  # Permission sets are managed by Aurita, however, so 
  # they have to be registered. 
  #
  # Example: 
  #
  #   register_permission(:create_shop_items, :default => false)
  #
  # Registered permissions can be validated now: 
  #
  #   if Aurita.user.may(:create_shop_items) then ...
  #
  # Permissions are granted in Aurita's default user 
  # management interfaces. 
  #
  # See also: Plugin_Register
  #
  def self.register_permission(name, params={}, &block)
    params[:plugin] = plugin_name
    permission = Aurita::Permission.new(name, params)
    Plugin_Register.add_permission(self, permission)
  end

end

end
