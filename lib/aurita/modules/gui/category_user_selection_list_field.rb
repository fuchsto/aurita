
require('aurita')
require('aurita-gui')
require('aurita-gui/widget')

Aurita.import_module :gui, :i18n_helpers

Aurita::Main.import_model :category
Aurita::Main.import_model :user_category

module Aurita
module GUI

  class Category_User_Selection_List_Field < Selection_List_Field
  include Aurita::GUI::I18N_Helpers

    attr_accessor :category, :read_access, :write_access, :select_field_name

    class Category_User_Selection_List_Option_Field < Selection_List_Option_Field
    include Aurita::GUI::I18N_Helpers

      def initialize(params={})
        super(params)
        @category = @parent.category
        @read     = @parent.read_access[@value.to_s]? 'read' : nil
        @write    = @parent.write_access[@value.to_s]? 'write' : nil
      end
      def element

        access_checkbox = Aurita::GUI::Checkbox_Field.new(:name => "user_#{@value}_permissions", 
                                                          :id   => "user_#{@value}_permissions", 
                                                          :option_values => [ 'read', 'write' ], 
                                                          :option_labels => [ tl(:read_permission), tl(:write_permission) ], 
                                                          :value => [ @read, @write ] ).element

        toggle_read  = "Aurita.call('User_Category/toggle_read_permission/user_group_id=#{@value}&category_id=#{@category.category_id}'); return true; "
        toggle_write = "Aurita.call('User_Category/toggle_write_permission/user_group_id=#{@value}&category_id=#{@category.category_id}'); return true; "
        access_checkbox[0].first.onchange = toggle_read
        access_checkbox[1].first.onchange = toggle_write

        HTML.div { 
          HTML.a(:class => :icon, 
                 :onclick => "Aurita.call({ method: 'POST', 
                                            onload: function() { Aurita.load({ element: 'user_category_list', 
                                                                               action: 'User_Category/user_list/category_id=#{@category.category_id}' }); }, 
                                            action: 'User_Category/perform_delete/user_group_id=#{@value}&category_id=#{@category.category_id}' });") { 
            HTML.img(:src => '/aurita/images/icons/delete_small.png')
          } + 
          @label.to_s + HTML.div { read_checkbox } + HTML.div { access_checkbox } 
        }
      end
    end

    def initialize(params={})
      @category     = params[:category]
      @read_access  = {}
      @write_access = {}
      
      @select_field_name = params[:name] # Otherwise '_select' would be appended to name of select field
      
      params.delete(:category)
      users = []
      User_Category.members_of(@category).each { |u|
          users << u.user_group_id
          @read_access[u.user_group_id.to_s]  = u.read_permission
          @write_access[u.user_group_id.to_s] = u.write_permission
      }
      options        = []
      user_group_ids = []
      User_Profile.all_with(User_Login_Data.deleted == 'f').order_by(User_Profile.surname).each { |u|
        if !(['0','5'].include?(u.user_group_id.to_s)) then
          options << u.label
          user_group_ids << u.user_group_id
        end
      }
      options.fields = user_group_ids.map { |v| v.to_s }
   
      super(params)
      set_options(options) 
      set_value(users)

      @option_field_decorator = Category_User_Selection_List_Option_Field
    end

  end

end
end

