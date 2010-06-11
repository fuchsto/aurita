
require('aurita')
require('aurita-gui')
require('aurita-gui/widget')

Aurita.import_module :gui, :i18n_helpers
Aurita.import_module :hierarchy_map_iterator

Aurita.import_module :gui, :datetime_fields
Aurita.import_module :gui, :category_select_field
Aurita.import_module :gui, :category_selection_list_field
Aurita.import_module :gui, :user_category_selection_list_field
Aurita.import_module :gui, :category_user_selection_list_field
Aurita.import_module :gui, :user_role_selection_list_field
Aurita.import_module :gui, :user_group_selection_list_field

Aurita.import_module :gui, :extras, :decofield
Aurita.import_module :gui, :extras, :decobox

module Aurita
module GUI

  class Text_Editor_Field < Aurita::GUI::Widget

    def initialize(params={}, &block)
      @attrib = params
      @value  = yield if block_given?
      @attrib[:class] ||= []
      @attrib[:class]  << [ :editor, :simple, :widget ]
      super()
    end

    def dom_id
      @attrib[:id]
    end

    def element
      @field ||= GUI::Textarea_Field.new(@attrib)
      @field
    end

    def js_initialize

      "Event.observe($('#{@attrib[:id]}_ifr').contentDocument, 'focus', 
                     function() { Aurita.form_field_onfocus('#{@attrib[:id]}') });
       Event.observe($('#{@attrib[:id]}_ifr').contentDocument, 'blur', 
                     function() { Aurita.form_field_onblur('#{@attrib[:id]}') });"

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
      HTML.div { Input_Field.new(@attrib).decorated_element + HTML.div(:id => :autocomplete_username_choices, :class => :autocomplete, :force_closing_tag => true, :style => 'position: relative !important;' ) }
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
      @onselect    ||= ''
      super(params, &block)
      @data_type = false
      add_css_class(:search)
    end
    def element
      HTML.div.form_field { 
        Input_Field.new(@attrib).decorated_element + 
        HTML.div(:id                => :autocomplete_tags_choices, 
                 :class             => :autocomplete, 
                 :force_closing_tag => true) 
      }
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

  class Language_Select_Field < Aurita::GUI::Widget
  include Aurita::GUI::I18N_Helpers
    
    def initialize(params={})
      @parent = params[:parent]
      @attrib = params
      @attrib.delete(:parent)
      if !@attrib[:value] then
        @attrib[:option_values] = [ '' ]
        @attrib[:option_labels] = [ tl(:select_additional_language) ]

        @attrib[:option_values] = [ :de, :en, :fr ]
        @attrib[:option_labels] = [ 'deutsch', 'englisch', 'franz&ouml;sisch' ]
      end
      @attrib[:onchange] = "Aurita.GUI.language_selection_add('#{@parent.dom_id}');" if @parent
      super()
    end

    def element
      Select_Field.new(@attrib)
    end
  end

  class Language_Selection_List_Field < Selection_List_Field
  include Aurita::GUI::I18N_Helpers

    class Language_Selection_List_Option_Field < Selection_List_Option_Field
      def initialize(params={})
        super(params)
      end
      def element
        HTML.div { 
          Hidden_Field.new(:name => 'languages[]', :value => @value) + 
          HTML.a(:onclick => "Element.remove('#{@parent.dom_id}');", :class => :icon) { 
            HTML.img(:src => '/aurita/images/icons/delete_small.png') 
          } + 
          HTML.span { @label }
        }
      end
    end
    
    def initialize(params={}, &block)
      @option_field_decorator ||= Language_Selection_List_Option_Field
      @select_field_class     ||= Language_Select_Field
      
      selected_languages = params[:value] || []
      
      params[:name]  = :languages if params[:name].to_s.empty?
      params[:label] = tl(:languages) unless params[:label]
      
      option_values = [ '', :de, :en, :fr ]
      option_labels = [ tl(:select_additional_language), 'deutsch', 'englisch', 'franz&ouml;sisch' ]
      
      options        = option_labels
      options.fields = option_values
      
      super(params, &block)
      
      set_options(options)
      set_value(selected_languages)
    end
  end


  class Single_Category_Select_Field < Select_Field
  include Aurita::GUI::I18N_Helpers

    def initialize(params={}, &block)
      values = [ '' ]
      labels = [ tl(:no_category) ]
    
      cats = Category.all_with(Category.is_private == 'f').sort_by(:category_name, :asc).to_a
      dec  = Hierarchy_Map_Iterator.new(cats)
      dec.each_with_level { |cat, level|
        values    << cat.category_id
        cat_label = ''
        level.times { cat_label << '|&nbsp;&nbsp;' }
        cat_label << cat.category_name
        labels    << cat_label
      }
     
      params[:option_labels] = labels
      params[:option_values] = values

      super(params, &block)
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
        element_id = 'user_selection_option_' + @value if @parent
        HTML.div(:id => element_id) { 
          Hidden_Field.new(:name => 'user_group_ids[]', :value => @value) + 
          HTML.a(:onclick => "Element.remove('#{element_id}');", :class => :icon) { 
            HTML.img(:src => '/aurita/images/icons/delete_small.png') 
          } + HTML.span { @label.to_s }
        }
      end
    end
    
    def initialize(params={}, &block)
      @option_field_decorator = User_Selection_List_Option_Field
      @select_field_class     = Username_Autocomplete_Field
      super(params, &block)
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

