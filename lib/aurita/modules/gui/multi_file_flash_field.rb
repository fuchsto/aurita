
require('aurita')
require('aurita-gui/html')
require('aurita-gui/form/file_field')
Aurita.import_module :gui, :i18n_helpers
Aurita.import_module :gui, :erb_template

module Aurita
module GUI

  class Multi_File_Flash_Field < Aurita::GUI::File_Field
  include Aurita::GUI
  include Aurita::GUI::I18N_Helpers

    def initialize(params)
      super(params)
      @erb_template ||= Aurita::GUI::ERB_Template
    end

    def element
      params = { :token => Aurita.user.user_group_id }
      HTML.div(:id => @attrib[:id]) { 
        @erb_template.new('flash_file_upload_field.rhtml', params).string
      }
    end

  end

end
end

