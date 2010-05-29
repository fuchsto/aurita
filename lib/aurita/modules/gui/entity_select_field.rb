
require('aurita')
require('aurita-gui')
require('aurita-gui/widget')

Aurita.import_module :gui, :i18n_helpers

module Aurita
module GUI

  # Widget building a GUI::Select_Field with entries in @entities as options. 
  # As known from GUI::Select_Field, options having a primary key value that 
  # is already present in @value (an Array of primary keys) are skipped. 
  # Calls 'Aurita.Main.selection_list_add(@parent.dom_id)
  #
  class Entity_Select_Field < Aurita::GUI::Widget
  include Aurita::GUI::I18N_Helpers
    
    # Paramters: 
    # :parent   - This widget's parent GUI element. 
    # :value    - Selected value for GUI::Select_Field
    # :entities - Optional. Entities to use in select field. Retreives 
    #             entities from @parent it provides method #entities. 
    #
    def initialize(params={})
      @parent   ||= params[:parent]
      @entities ||= params[:entities]
      @entities ||= @parent.entities if @parent && @parent.respond_to?(:entities)
      @attrib   ||= params
      @attrib.delete(:parent)
      @attrib.delete(:entities)
      
      if !@attrib[:options] && !@attrib[:option_values] then
        @attrib[:option_values] ||= [ '' ]
        @attrib[:option_labels] ||= [ tl(:select_option) ]
        @entities.each { |e|
          @attrib[:option_values] << e.pkey
          @attrib[:option_labels] << e.label
        }
      end
      
      if @attrib[:name].empty? then
        @attrib[:name] ||= @entities.first.class.primary_key_name if @entities.first
      end
      if @parent then
        @attrib[:onchange] ||= "Aurita.Main.selection_list_add({ select_field:'#{@attrib[:id]}', 
                                                                 name: '#{@parent.options_name}' });" 
      end
      
      super()
    end

    def element
      Select_Field.new(@attrib)
    end
  end
  
end
end

