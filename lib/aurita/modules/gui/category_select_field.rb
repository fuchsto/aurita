
require('aurita')
require('aurita-gui')
require('aurita-gui/widget')

Aurita.import_module :gui, :i18n_helpers

module Aurita
module GUI

  # Widget building a GUI::Select_Field with all public categories as options. 
  # As known from GUI::Select_Field, options having a category id that is 
  # already present in @value (an Array of category ids) are skipped. 
  # Calls 'Aurita.Main.category_selection_add(@parent.dom_id)
  #
  class Category_Select_Field < Aurita::GUI::Widget
  include Aurita::GUI::I18N_Helpers
    
    # Paramters: 
    # :parent - This widget's parent GUI element. 
    # :value  - Selected value for GUI::Select_Field
    #
    def initialize(params={})
      @parent = params[:parent]
      @attrib = params
      @attrib.delete(:parent)
      if !@attrib[:value] then
        @attrib[:option_values] = [ '' ]
        @attrib[:option_labels] = [ tl(:select_additional_category) ]
        cats = Category.all_with(Category.is_private == 'f').sort_by(:category_name, :asc).to_a
        dec  = Hierarchy_Map_Iterator.new(cats)
        dec.each_with_level { |cat, level|
          cat_label = ''
          level.times { cat_label << '&nbsp;&nbsp;' }
          cat_label << cat.category_name
          @attrib[:option_values] << cat.category_id
          @attrib[:option_labels] << cat_label 
        }
      end
      @attrib[:onchange] = "Aurita.Main.selection_list_add({ select_field:'#{@parent.dom_id}', 
                                                             name: 'public.category.category_id' });" if @parent
      super()
    end

    def element
      Select_Field.new(@attrib)
    end
  end
  
end
end

