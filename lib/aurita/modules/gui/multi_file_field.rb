
require('aurita')
require('aurita-gui/html')
require('aurita-gui/form/file_field')
Aurita.import_module :gui, :i18n_helpers

module Aurita
module GUI

  class Multi_File_Field < Aurita::GUI::File_Field
  include Aurita::GUI
  include Aurita::GUI::I18N_Helpers

    def initialize(params)
      super(params)
    end

    def element
      first       = super()
      entries_id  = @attrib[:id] + '_entries'
      append_file = "Aurita.load_widget('Wiki::Multi_File_Entry_Field', 
                                              { 
                                                name: '#{@attrib[:name]}', 
                                                id: '#{@attrib[:id]}_entry' 
                                              }, 
                                              Aurita.append_widget_to('#{entries_id}'));"
      HTML.div(:id => @attrib[:id]) { 
        first + 
        HTML.div(:id => entries_id) { ' ' } +
        HTML.a(:class => [:button, :add_button, :add_file_button ], 
               :onclick => append_file) { tl(:add_another_file) }
      }
    end

  end

end
end

