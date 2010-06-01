
require('aurita')
require('aurita-gui')
require('aurita-gui/widget')
Aurita.import_module :gui, :i18n_helpers
Aurita.import_module :gui, :entity_selection_list_field
Aurita.import_module :gui, :category_select_field

module Aurita
module GUI

  class Category_Selection_List_Field < Selection_List_Field
  include Aurita::GUI::I18N_Helpers
    
    def initialize(params={}, &block)
      @option_field_decorator ||= Entity_Selection_List_Field::Entity_Selection_List_Option_Field
      @select_field_class     ||= Category_Select_Field
      
      params[:name]  = Category.category_id.to_s if params[:name].empty?
      params[:label] = tl(:categories) unless params[:label]
      
      user           = params[:user]
      content        = params[:content]
      user         ||= Aurita.user
      user_cat       = user.category
      option_values  = []
      option_labels  = []
      category_ids   = []
      category_names = []
      private_category_names  = []
      private_category_ids    = []
      selected_category_ids   = content.category_ids if content
      selected_category_ids ||= params[:value]
      selected_category_ids ||= [ user.category_id ]
      
      own_category_id = user.category_id
      
      cats = user.writeable_categories
      dec  = Hierarchy_Map_Iterator.new(cats)
      dec.each_with_level { |cat, level|
        cat_label = ''
        level.times { cat_label << '&nbsp;&nbsp;' }
        cat_label << cat.category_name

        if cat.is_private then 
          if cat.category_id.to_s != own_category_id.to_s then
            private_category_names << (tl(:user) + ': ' << cat.category_name)
            private_category_ids   << cat.category_id
          end
        else
          category_names << cat_label
          category_ids   << cat.category_id
        end
      }
      
      option_values = ['', own_category_id.to_s] + category_ids
      option_labels = [tl(:select_additional_category), tl(:your_private_category)] + category_names
      if Aurita.user.is_admin? then
        option_values += private_category_ids
        option_labels += private_category_names
      end
      
      options = option_labels
      begin
        options.fields = option_values.map { |v| v.to_s }
      rescue ::Exception => e
        raise ::Exception.new("Failed arrayfields values: #{option_values.inspect}")
      end
      
      params.delete(:user)
      params.delete(:content)
      params[:value] = selected_category_ids
      
      super(params, &block)
      
      set_options(options)
      set_value(selected_category_ids)
    end
  end

end
end


