
require('aurita')
require('aurita-gui')
require('aurita-gui/widget')

Aurita.import_module :gui, :i18n_helpers
Aurita.import_module :hierarchy_map_iterator

Aurita::Main.import_model :category
Aurita::Main.import_model :user_category

module Aurita
module GUI

  # Specialization of Aurita::GUI::Selection_List_Field:
  # Sets
  #   options: All available categories
  #   value: Array of category ids currently assigned to user
  # Expects: 
  #   user: Instance of user to create selection list for
  #
  class User_Category_Selection_List_Field < Selection_List_Field
  include Aurita::GUI::I18N_Helpers

    attr_accessor :user, :read_access, :write_access, :select_field_name

    class User_Category_Selection_List_Option_Field < Selection_List_Option_Field
    include Aurita::GUI::I18N_Helpers

      def initialize(params={})
        super(params)
        @user     = @parent.user
        @read     = @parent.read_access[@value.to_s]? 'read' : nil
        @write    = @parent.write_access[@value.to_s]? 'write' : nil
      end
      def element
        access_checkbox = Aurita::GUI::Checkbox_Field.new(:name => "user_#{@value}_permissions", 
                                                          :id   => "user_#{@value}_permissions", 
                                                          :option_values => [ 'read', 'write' ], 
                                                          :option_labels => [ tl(:read_permission), tl(:write_permission) ], 
                                                          :value => [ @read.to_s, @write.to_s ] ).element

        toggle_read  = "Aurita.call('User_Category/toggle_read_permission/user_group_id=#{@user.user_group_id}&category_id=#{@value}'); return true; "
        toggle_write = "Aurita.call('User_Category/toggle_write_permission/user_group_id=#{@user.user_group_id}&category_id=#{@value}'); return true; "
        access_checkbox[0].first.onchange = toggle_read
        access_checkbox[1].first.onchange = toggle_write

        HTML.div { 
          HTML.a(:class => :icon, 
                 :onclick => "Aurita.load({ element: 'dispatcher', 
                                            onload: function() { Aurita.load({ element: 'user_category_list', 
                                                                               action: 'User_Category/category_list/user_group_id=#{@user.user_group_id}' }); }, 
                                            action: 'User_Category/perform_delete/user_group_id=#{@user.user_group_id}&category_id=#{@value}' });") { 
            HTML.img(:src => '/aurita/images/icons/delete_small.png') 
          } + 
          @label.to_s + HTML.div { read_checkbox } + HTML.div { access_checkbox } 
        }
      end # element
    end # class User_Selection_List_Option_Field

    def initialize(params={})
      @user         = params[:user]
      @read_access  = {}
      @write_access = {}

      @select_field_name = params[:name] # Otherwise '_select' would be appended to name of select field

      params.delete(:user)
      active_categories = []
      User_Category.categories_of(@user).each { |c|
        if c.is_private != 't' then
          active_categories << c.category_id
          @read_access[c.category_id.to_s]  = c.read_permission
          @write_access[c.category_id.to_s] = c.write_permission
        end
      }
      options = []
      cat_ids = []

      cats = Category.all_with((Category.is_private == 'f') & (Category.category_id >= 100)).sort_by(Category.category_name).to_a
      dec  = Hierarchy_Map_Iterator.new(cats)
      dec.each_with_level { |cat, level|
        cat_label = ''
        level.times { cat_label << '&nbsp;&nbsp;' }
        cat_label << cat.category_name

        if cat.is_private == 't'
          options << (tl(:user) + ': ' + cat.category_name) 
        else
          options << cat_label
        end
        cat_ids << cat.category_id
      } 

      options.fields = cat_ids.map { |v| v.to_s }
   
      super(params)
      set_options(options) 
      set_value(active_categories)

      @option_field_decorator = User_Category_Selection_List_Option_Field
    end # initialize

  end # class User_Category_Selection_List_Field

end # module GUI
end # module Aurita


