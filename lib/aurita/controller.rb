
require('aurita')

Aurita.import('base/controller')
Aurita.import_module :gui, :helpers
Aurita.import_module :gui, :i18n_helpers
Aurita.import_module :gui, :datetime_helpers
Aurita.import_module :gui, :erb_template
Aurita.import_module :gui, :form_generator
Aurita.import_module :file_helpers
Aurita.import_module :tagging
Aurita.import :base, :plugin_register

module Aurita

module Plugins
end

  # Extends Aurita::Base_Controller by helper modules 
  # like I18N_Helpers, Datetime_Helpers, GUI::Helpers, 
  # etc. 
  # Derive from this controller class when implementing 
  # controllers for aurita itself, that is, 
  # Aurita::Main. Use Aurita::Main::Plugin_Controller 
  # in plugins. 
  #
  # App_Controller includes the following helper modules: 
  #
  # - Aurita::GUI::Helpers
  # - Aurita::GUI::I18N_Helpers
  # - Aurita::GUI::Datetime_Helpers
  # - Aurita::File_Helpers
  #
  class App_Controller < Aurita::Base_Controller
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
    @@erb_template   = Aurita::GUI::ERB_Template

  end

end # module

