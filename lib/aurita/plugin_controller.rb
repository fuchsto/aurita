
require('aurita')

Aurita.import :base, :controller
Aurita.import_module :gui, :helpers
Aurita.import_module :gui, :i18n_helpers
Aurita.import_module :gui, :datetime_helpers
Aurita.import_module :gui, :erb_template
Aurita.import_module :gui, :form_generator
Aurita.import_module :file_helpers
Aurita.import_module :tagging
Aurita.import :base, :plugin_register

module Plugins
end

# Extends Aurita::Base_Controller by helper modules 
# like I18N_Helpers, Datetime_Helpers, GUI::Helpers, 
# etc. 
# Behaves exactly like Aurita::Main::App_Controller, but 
# with search paths extended by this plugins base path. 
#
# Derive from this class when implementing a controller 
# for a plugin. 
#
class Aurita::Plugin_Controller < Aurita::Base_Controller 
include Aurita::GUI
include Aurita::GUI::Helpers
include Aurita::GUI::I18N_Helpers
include Aurita::GUI::Datetime_Helpers
include Aurita::File_Helpers
extend Aurita::File_Helpers
extend Aurita::GUI::Helpers
include Aurita::Plugins
extend Aurita::Plugins

  @@form_generator = Aurita::GUI::Form_Generator
  @@erb_template = Aurita::GUI::ERB_Template

  # Redefines App_Controller.render_view to load view
  # templates from plugin directorry. 
  #
  def render_view(template, params={})
    params[:controller] = self
    template = "#{template}.rhtml" if template.instance_of? Symbol
    content = @@erb_template.new(template, params, plugin_name()).string
    @response[:html] << content
    @response[:script] << params[:script] if params[:script]
  end

  # Redefines App_Controller.view_string to load view
  # templates from plugin directorry. 
  #
  def view_string(template, params={})
    params[:controller] = self
    template = "#{template}.rhtml" if template.instance_of? Symbol
    @@erb_template.new(template.to_s, params, plugin_name()).string
  end

end

include Aurita
include Aurita::Main

