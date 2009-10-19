
require('aurita')
require('aurita-gui')
require('aurita-gui/widget')
# Aurita.import_module :gui, :erb_helpers
Aurita.import_module :gui, :i18n_helpers

module Aurita
module GUI

  class Text_Editor_Field < Textarea_Field
    def initialize(params={}, &block)
      super(params, &block)
      add_css_class('editor')
      add_css_class('simple')
    end
  end

  class Full_Text_Editor_Field < Textarea_Field
    def initialize(params={}, &block)
      super(params, &block)
      add_css_class('editor')
      add_css_class('full')
    end
  end

  class Boolean_Radio_Field < Radio_Field
  include Aurita::GUI::I18N_Helpers

    def initialize(params={}, &block)
      super(params, &block)
      set_options([ true, false ])
      set_option_labels([ tl(:yes), tl(:no) ])
    end
  end

  class Username_Autocomplete_Field < Aurita::GUI::Form_Field
  include Aurita::GUI::I18N_Helpers

    attr_accessor :onselect

    def initialize(params={}, &block) 
      params[:id]    = :autocomplete_username # unless params[:id]
      params[:name]  = :usernames # unless params[:name]
      params[:class] = 'lore inline' unless params[:class]
      @onselect      = params[:onselect]
      @onselect    ||= "alert('Username_Autocomplete_Field.onselect('+li.id+'));"
      super(params, &block)
      @data_type = false
    end
    def element
      HTML.div { Input_Field.new(@attrib) + HTML.div(:id => :autocomplete_username_choices, :class => :autocomplete, :force_closing_tag => true) }
    end
    def js_initialize()
code =<<JS 
      autocomplete_selected_users = {}; 
      new Ajax.Autocompleter("autocomplete_username", 
                             "autocomplete_username_choices", 
                             "/aurita/poll", 
                             { 
                               minChars: 2, 
                               updateElement: function(li) { #{@onselect} } , 
                               frequency: 0.1, 
                               tokens: [], 
                               parameters: 'controller=Autocomplete&action=usernames&mode=none'
                             }
      );
JS
      code
    end
  end

  class Tag_Autocomplete_Field < Aurita::GUI::Form_Field
  include Aurita::GUI::I18N_Helpers

    attr_accessor :onselect

    def initialize(params={}, &block) 
      params[:id]    = :autocomplete_tags # unless params[:id]
      params[:name]  = :tags unless params[:name]
      params[:class] = 'lore inline' unless params[:class]
      @onselect      = params[:onselect]
      @onselect    ||= "alert('Username_Autocomplete_Field.onselect('+li.id+'));"
      super(params, &block)
      @data_type = false
    end
    def element
      HTML.div { Input_Field.new(@attrib) + HTML.div(:style => "position: relative !important;", :id => :autocomplete_tags_choices, :class => :autocomplete, :force_closing_tag => true) }
    end
    def js_initialize()
code =<<JS 
      autocomplete_selected_users = {}; 
      new Ajax.Autocompleter("autocomplete_username", 
                             "autocomplete_username_choices", 
                             "/aurita/poll", 
                             { 
                               minChars: 2, 
                               updateElement: function(li) { #{@onselect} } , 
                               frequency: 0.1, 
                               tokens: [], 
                               parameters: 'controller=Autocomplete&action=usernames&mode=none'
                             }
      );
JS
      code
    end
  end

  class Picture_Asset_Field < Aurita::GUI::Form_Field
  include Aurita::GUI::I18N_Helpers
    
    attr_accessor :preview_width

    def initialize(params, &block)
      @preview_width = params[:preview_width]
      @preview_width ||= 300
      params.delete(:preview_width)
      super(params, &block)
    end

    def element
      visibility   = 'none' unless @value.to_s != ''
      visibility ||= 'block'
      HTML.div.picture_asset_field { 
        HTML.img(:id => 'picture_asset_' << dom_id(), 
                 :src => "/aurita/assets/medium/asset_#{@value}.jpg", 
                 :class => :picture_asset_element_preview, 
                 :style => "display: #{visibility}") + 
        HTML.div.button_bar { 
          Text_Button.new(:onclick => "Aurita.Wiki.select_media_asset({ hidden_field: '#{dom_id()}',
                                                                        user_id: ''});") { tl(:select_image) } + 
          Text_Button.new(:onclick => "Aurita.load({ action: 'Wiki::Media_Asset/add_profile_image/' });", 
                          :id => "upload_profile_image_button_#{dom_id()}" ) { tl(:upload_image) }+ 
          Text_Button.new(:onclick => "Aurita.Wiki.select_media_asset_click(0, '#{dom_id()}');", 
                          :id => "clear_selected_image_button_#{dom_id()}" ) { tl(:clear_image) } 
        } + 
        Hidden_Field.new(:id => dom_id(), :value => @value, :name => @attrib[:name]) + 
        HTML.div(:class => :media_asset_selection, :id => "select_box_#{dom_id()}", :force_no_close => true)
      }
    end

  end # class Picture_Asset_Field

  class Category_Select_Field < Aurita::GUI::Widget
  include Aurita::GUI::I18N_Helpers
    
    def initialize(params={})
      @parent = params[:parent]
      @attrib = params
      @attrib.delete(:parent)
      if !@attrib[:value] then
        @attrib[:option_values] = [ '' ]
        @attrib[:option_labels] = [ tl(:select_additional_category) ]
        Category.all_with(Category.is_private == 'f').sort_by(:category_name, :asc).each { |c|
          @attrib[:option_values] << c.category_id
          @attrib[:option_labels] << c.category_name
        }
      end
      @attrib[:onchange] = "Aurita.Main.category_selection_add('#{@parent.dom_id}');" if @parent
      super()
    end

    def element
      select_field = Select_Field.new(@attrib)
      if @parent then
        button       = Text_Button.new(:class   => :add_category_button, 
                                       :onclick => "Aurita.Main.category_selection_add('#{@parent.dom_id}');") { '+' }
        return HTML.div.category_select_field { 
          select_field
        }
      else 
        return select_field
      end
    end
  end

  class Category_Selection_List_Field < Selection_List_Field
  include Aurita::GUI::I18N_Helpers

    class Category_Selection_List_Option_Field < Selection_List_Option_Field
      def initialize(params={})
        super(params)
      end
      def element
        HTML.div { 
          Hidden_Field.new(:name => 'category_ids[]', :value => @value) + 
          HTML.a(:onclick => "Element.remove('#{@parent.dom_id}');", :class => :icon) { HTML.img(:src => '/aurita/images/icons/delete_small.png') } + HTML.span { @label }
        }
      end
    end
    
    def initialize(params={}, &block)
      @option_field_decorator ||= Category_Selection_List_Option_Field
      @select_field_class     ||= Category_Select_Field

      params[:name]  = Category.category_id if params[:name].to_s.empty?
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
      
      user.writeable_categories.each { |c|
        if c.is_private then 
          if c.category_id.to_s != own_category_id.to_s then
            private_category_names << (tl(:user) + ': ' << c.category_name)
            private_category_ids   << c.category_id
          end
        else
          category_names << c.category_name
          category_ids << c.category_id
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


  # Specialization of Aurita::GUI::Selection_List_Field:
  # Sets
  #   options: All available categories
  #   value: Array of category ids currently assigned to user
  # Expects: 
  #   user: Instance of user to create selection list for
  #
  class User_Category_Selection_List_Field < Selection_List_Field
  include Aurita::GUI::I18N_Helpers

    attr_accessor :user, :readonly_permissions

    class User_Category_Selection_List_Option_Field < Selection_List_Option_Field
    include Aurita::GUI::I18N_Helpers

      def initialize(params={})
        super(params)
        @user                = @parent.user
        @readonly_permission = @parent.readonly_permissions[@value.to_s]
      end
      def element
        readonly_checkbox = Aurita::GUI::Checkbox_Field.new(:name => "category_#{@value}_readonly", 
                                                            :options => { 't' => tl(:readonly_permission) }, 
                                                            :value => @readonly_permission ).element
        readonly_checkbox.each { |e| 
          e.first.onclick = "Aurita.call('User_Category/toggle_readonly/user_group_id=#{@user.user_group_id}&category_id=#{@value}');"
        }

        HTML.div { 
          HTML.span(:class => :link, 
                    :onclick => "Aurita.load({ element: 'dispatcher', 
                                               onload: function() { Aurita.load({ element: 'user_category_list', 
                                                                                  action: 'User_Category/category_list/user_group_id=#{@user.user_group_id}' }); }, 
                                               action: 'User_Category/perform_delete/user_group_id=#{@user.user_group_id}&category_id=#{@value}' });") { 
            HTML.img(:src => '/aurita/images/icons/delete_small.png') 
          } + 
          @label.to_s + HTML.div { readonly_checkbox }
        }
      end
    end

    def initialize(params={})
      @user = params[:user]
      @readonly_permissions = {}
      params.delete(:user)
      active_categories = []
      @user.categories.each { |c|
        if c.is_private != 't' then
          active_categories << c.category_id
          @readonly_permissions[c.category_id.to_s] = c.readonly
        end
      }
      options = []
      cat_ids = []
      Category.all_with((Category.is_private == 'f') & (Category.category_id >= 100)).sort_by(Category.category_name).each { |c|
        if c.is_private == 't'
          options << (tl(:user) + ': ' + c.category_name) 
        else
          options << c.category_name
        end
        cat_ids << c.category_id
      }
      options.fields = cat_ids.map { |v| v.to_s }
   
      super(params)
      set_options(options) 
      set_value(active_categories)

      @option_field_decorator = User_Category_Selection_List_Option_Field
    end

  end

  class Category_User_Selection_List_Field < Selection_List_Field
  include Aurita::GUI::I18N_Helpers

    attr_accessor :category, :readonly_permissions

    class Category_User_Selection_List_Option_Field < Selection_List_Option_Field
    include Aurita::GUI::I18N_Helpers

      def initialize(params={})
        super(params)
        @category            = @parent.category
        @readonly_permission = @parent.readonly_permissions[@value.to_s]
      end
      def element
        read_checkbox = Aurita::GUI::Checkbox_Field.new(:name => "user_#{@value}_readonly", 
                                                        :options => { 'true' => tl(:read_permission) }, 
                                                        :value => @readonly_permission.to_s ).element
        write_checkbox = Aurita::GUI::Checkbox_Field.new(:name => "user_#{@value}_readonly", 
                                                         :options => { 'true' => tl(:write_permission) }, 
                                                         :value => @readonly_permission.to_s ).element
        read_checkbox.each { |e| 
          e.first.onclick = "Aurita.call('User_Category/toggle_readonly/user_group_id=#{@value}&category_id=#{@category.category_id}');"
        }
        write_checkbox.each { |e| 
          e.first.onclick = "Aurita.call('User_Category/toggle_write/user_group_id=#{@value}&category_id=#{@category.category_id}');"
        }

        HTML.div { 
          HTML.span(:class => :link, 
                    :onclick => "Aurita.call({ method: 'POST', 
                                               onload: function() { Aurita.load({ element: 'user_category_list', 
                                                                                  action: 'User_Category/user_list/category_id=#{@category.category_id}' }); }, 
                                               action: 'User_Category/perform_delete/user_group_id=#{@value}&category_id=#{@category.category_id}' });") { 
            HTML.img(:class => :icon, :src => '/aurita/images/icons/delete_small.png')
          } + 
          @label.to_s + HTML.div { read_checkbox } + HTML.div { write_checkbox } 
        }
      end
    end

    def initialize(params={})
      @category = params[:category]
      @readonly_permissions = {}
      params.delete(:category)
      users = []
      @category.users.each { |u|
          users << u.user_group_id
          @readonly_permissions[u.user_group_id.to_s] = u.readonly
      }
      options        = []
      user_group_ids = []
      User_Login_Data.all_with(User_Login_Data.deleted == 'f').order_by(User_Group.user_group_name).each { |u|
        if !(['0','5'].include?(u.user_group_id.to_s)) then
          options << u.user_group_name
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


  class User_Selection_List_Field < Selection_List_Field
  include Aurita::GUI::I18N_Helpers

    class User_Selection_List_Option_Field < Selection_List_Option_Field
      def initialize(params={})
        @parent = params[:parent]
        params.delete(:parent)
        super(params)
      end
      def element
        element_id = @parent.name.to_s + '_' + @value if @parent
        p element_id
        element_id = 'user_selection_option_' + @value if @parent
        HTML.div(:id => element_id) { 
          Hidden_Field.new(:name => 'user_group_ids[]', :value => @value) + 
          HTML.span(:onclick => "Element.remove('#{element_id}');", :class => :link) { HTML.img(:src => '/aurita/images/icons/delete_small.png') } + HTML.span { @label.to_s }
        }
      end
    end
    
    def initialize(params={}, &block)
      @option_field_decorator = User_Selection_List_Option_Field
      @select_field_class     = Username_Autocomplete_Field
      super(params, &block)
    end
  end
  
  # Specialisation of Aurita::GUI::Selection_List_Field:
  # Sets
  #   options: All available roles
  #   value: Array of role ids currently assigned to user
  # Expects: 
  #   user: Instance of user to create selection list for
  #
  class User_Role_Selection_List_Field < Selection_List_Field
  include Aurita::GUI::I18N_Helpers

    attr_accessor :user

    class User_Role_Selection_List_Option_Field < Selection_List_Option_Field
      def initialize(params={})
        @user = params[:parent].user
        super(params)
      end
      def element
        HTML.div { 
          HTML.span(:class => :link, 
                    :onclick => "Aurita.call({ action: 'User_Role/perform_delete/user_group_id=#{@user.user_group_id}&role_id=#{@value}' });") { HTML.img(:src => '/aurita/images/icons/delete_small.png') } + 
          @label.to_s
        }
      end
    end

    def initialize(params={})
      @user = params[:user]
      params.delete(:user)
      active_roles = user.role_ids
      options = {}
      Role.find(:all).sort_by(Role.role_name).each { |c|
        options[c.role_id] = c.role_name
      }
      super(params)
      set_options(options)
      set_value(active_roles)
      @option_field_decorator = User_Role_Selection_List_Option_Field
    end
  end

  class Duration_Field < Form_Field
  include Aurita::GUI::I18N_Helpers

    def initialize(params, &block)
      @day_range = params[:day_range]
      @day_range ||= (0..7)
      @hour_range = params[:hour_range]
      @hour_range ||= (0..23)
      super(params, &block)
      @value ||= [0,0]
    end

    def element
      HTML.div { 
        HTML.div.duration_days { Select_Field.new(:name => "#{@attrib[:name]}_days", :options => @day_range, :value => @value[0]) +
         tl(:days) } + 
        HTML.div.duration_hours { Select_Field.new(:name => "#{@attrib[:name]}_hours", :options => @hour_range, :value => @value[1]) + 
         tl(:hours) } 
      }
    end
  end

  class Datepick_Field < Form_Field
  include Aurita::GUI::I18N_Helpers

    def initialize(params, &block)
      params[:id] = params[:name]
      super(params, &block)
      add_css_class(:datepick)
    end

    def element
      name = dom_id().to_s.gsub('.','_')
      trigger_name = "#{name}_trigger"
      trigger_onclick = "Aurita.GUI.open_calendar('#{name}','#{trigger_name}');"
      clear_onclick   = "$('#{name}').value = '';"

      @attrib[:onclick] = trigger_onclick
      HTML.div { 
        Input_Field.new(@attrib.update(:value => @value, :readonly => true, :id => name)) + 
        Text_Button.new(:class   => :datepick_clear, 
                        :onclick => clear_onclick) { 'X' }  + 
        Text_Button.new(:id      => trigger_name, 
                        :class   => :datepick, 
                        :onclick => trigger_onclick) { tl(:choose_date) } 
      }
    end
  end

  class Timespan_Field < Form_Field
  include Aurita::GUI::I18N_Helpers

    attr_accessor :from, :to

    def initialize(params={}, &block)
      @from = params[:value][0]
      @to   = params[:value][1]
      @minute_range = params[:minute_range]
      @minute_range ||= [0, 15, 30, 45]
      params.delete(:value)
      params.delete(:minute_range)
      params.delete(:time_format)
      super(params, &block)
    end

    def element
      name      = @attrib[:name]
      from_name = "#{name}_begin"
      to_name   = "#{name}_end"

      HTML.div { 
        Time_Field.new(:name => from_name, :value => @from, :class => :timespan, :time_format => 'hm', :minute_range => @minute_range) + 
        HTML.div(:class => :timespan_delimiter) { tl(:timespan_to) } + 
        Time_Field.new(:name => to_name, :value => @to, :class => :timespan, :time_format => 'hm', :minute_range => @minute_range) + 
        HTML.div(:style => 'clear: both;') { ' '}
      }

    end
  end

  class Category_Access_Options_Field < Select_Field
  include Aurita::GUI::I18N_Helpers

    def initialize(params)
      params[:option_values] = [ :public, :registered, :members ]
      params[:option_labels] = [ tl(:everyone), tl(:registered_users), tl(:members_of_category) ]
      params[:value]         = :members unless params[:value]
      super(params)
    end
  end

  class Country_Select_Field < Select_Field
    def initialize(params={}, &block)
      options = YAML.load(File.open(Aurita::Application.base_path + 'modules/gui/countries.yaml'))
      values  = options.keys.delete_if { |x| !x }.sort { |a,b| a <=> b }
      labels  = options.values
      params[:option_labels] = labels
      params[:option_values] = values
      super(params, &block)
    end
  end

end
end

