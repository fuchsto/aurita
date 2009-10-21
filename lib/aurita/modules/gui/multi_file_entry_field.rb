
require('aurita')
require('aurita-gui/html')
require('aurita-gui/form/file_field')
Aurita.import_module :gui, :i18n_helpers

module Aurita
module GUI

  class Multi_File_Entry_Field < Aurita::GUI::File_Field
  include Aurita::GUI

    def initialize(params)
      params[:id] = "#{params[:id].gsub('[]','')}_#{rand(1000)}".to_sym
      super(params)
    end

    def element
      field        = super()
      id           = @attrib[:id].to_s.dup
      field.id     = "#{field.id}_field"
      delete_field = "$('#{id}').innerHTML = '';"

      HTML.div.multi_file_entry(:id => id) { 
        field
     #  field + 
     #  HTML.a(:class   => [:button, :delete_button], 
     #         :onclick => delete_field) { '-' } 
      }
    end

  end


end
end

