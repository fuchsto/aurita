
require('aurita')
require('aurita-gui')
require('aurita-gui/form/select_field')

Aurita.import_module :gui, :i18n_helpers

module Aurita
module GUI

  # Widget building a GUI::Select_Field with entries in @entities as options. 
  # As known from GUI::Select_Field, options having a primary key value that 
  # is already present in @value (an Array of primary keys) are skipped. 
  # Calls 'Aurita.Main.selection_list_add(@parent.dom_id)
  #
  class Entity_Select_Field < Select_Field
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
      params   ||= params
      params.delete(:parent)
      params.delete(:entities)
      
      if !params[:options] && !params[:option_values] then
        params[:option_values] ||= [ '' ]
        params[:option_labels] ||= [ tl(:select_option) ]
        @entities.each { |e|
          params[:option_values] << e.pkey
          params[:option_labels] << e.label
        }
      end
      
      if params[:name].empty? then
        params[:name] ||= @entities.first.class.primary_key_name if @entities.first
      end
      if @parent then
        params[:onchange] ||= "Aurita.Main.selection_list_add({ select_field:'#{params[:id]}', 
                                                                 name: '#{@parent.options_name}' });" 
      end
      
      super(params)
    end

  end
  
end
end

