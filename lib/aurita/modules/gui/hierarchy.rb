
require('aurita/controller')
require('cgi')
Aurita.import_module :gui, :module
Aurita.import_module :gui, :box

module Aurita
module GUI

  class Hierarchy_Element < Element
    attr_accessor :model_instance, :label, :onclick, :class
    # Model instance has to include behaviour "Aurita::GUI::Hierarchy_Element_Behaviour"
    def initialize(model_instance)
      @tag     = :li
      @model_instance = model_instance
      @class   = 'hierarchy_entry'
      @label   = model_instance.entry_label.to_s
      @id      = model_instance.entry_key.to_s
      @onclick = nil
      @icon    = false
      @string  = false
    end
    def string
    # return @string if @string
      entry_params = { :class => @class, :onclick => @onclick } 
      @icon ||= :blank
      @string = HTML.li(entry_params) { "<img src=\"/aurita/images/icons/#{@icon}.gif\" /> #{@label}" }
      return @string
    end

    def inspect
      string()
    end
  end

  # Usage: 
  #
  #  h = Hierarchy_Map.new(Some_Hierarchy_Model.all_with(foo == 3).entities, 
  #                        :id => 'some_hierarchy')
  #  
  #  d = Hierarchy_Default_Decorator.new(h)
  #  d.entry_decorator = Some_Specific_Entry_Decorator
  #  d.build()
  # 
  class Hierarchy_Map

    attr_reader :entry_map, :entry_model
    
    def initialize(entries, dom_id='hierarchy_map')
      @entry_map = Hash.new
      @dom_id = dom_id
      for entry in entries do 
        pid = entry.parent_id # Has to be provided by model instance
        @entry_map[pid] = Array.new unless @entry_map[pid]
        map_element = Hierarchy_Element.new(entry)
        @entry_map[pid] << map_element
      end
      model_inst = @entry_map.values.first.first.model_instance if @entry_map.values.first
      @entry_model = model_inst.class if model_inst
    end

    def [](key)
      @entry_map[key]
    end
  end

  class Hierarchy_Entries_Default_Decorator
  # {{{
  extend Aurita::GUI::Helpers
  include Aurita::GUI::Helpers
  include Aurita::GUI

  private

    @string

  public
  
    attr_accessor :dom_id
  
    def initialize(hierarchy_map)
      @entry_map = hierarchy_map
      @string = recurse(0)
      @dom_id = 'sortable_hierarchy'
    end

    def recurse(parent_id, indent=1)
      return '' unless @entry_map[parent_id] 
      string = ''
      for e in @entry_map[parent_id] do

#       entry = plugin_get(Hook.main.hierarchy.entry_decorator, :entry => e)
        entry_id = e.model_instance.pkey_value

        label_string = decorate_entry(e)
        
        if @entry_map[entry_id] then
          next_level = HTML.ul(:class => 'no_bullets indent-' << indent.to_s) { recurse(entry_id, indent+1) }.string
        else
          next_level = ''
        end
        if label_string then
          string << HTML.li { label_string + next_level }.string
        end
      end
      return string
    end

    # Overload method decorate_entry to support other 
    # model instances for hierarchies
    def decorate_entry(e)
      e = e.model_instance
  
      if !e.allow_access?(Aurita.user) then
        return HTML.span.not_accessible { e.label } if Aurita.user.is_registered? 
        return ''
      end

      onclick = "Cuba.load({ action: '#{CGI.escape(e.interface).gsub('%2F','/').gsub('%3D','=')}' }); "
      label_style = 'padding: 2px; margin: -2px; '
      if e.attr[:entry_type] == 'BLANK_NODE' then
        label_style << 'color: black; '
      end

      params = { :hierarchy_entry_id => e.hierarchy_entry_id, 
                 :hierarchy_id       => e.hierarchy_id }
      return Context_Menu_Element.new(HTML.div.link(:style => label_style, :onclick => onclick) { e.label }, 
                                      :entity => e, 
                                      :params => params)
    end

    def string
      if @string.length > 0 then
        return HTML.ul(:class => :no_bullets, :id => @dom_id.to_s ) { @string }.string
      else 
        return nil
      end
    end
  end # }}}

  class Hierarchy_Entries_Accordion_Decorator < Hierarchy_Entries_Default_Decorator
  # {{{
  extend Aurita::GUI::Helpers
  include Aurita::GUI::Helpers
  include Aurita::GUI

  public
  
    attr_accessor :dom_id
  
    def initialize(hierarchy_map)
      @entry_map = hierarchy_map
      @string = recurse('0')
      @dom_id = 'accordion_hierarchy'
    end

    def recurse(parent_id, indent=1)
      return '' unless @entry_map[parent_id] 
      string = ''
      for e in @entry_map[parent_id] do
        entry_id = e.model_instance.pkey_value

        if @entry_map[entry_id] then
          entry   = e.model_instance
          onclick = "Cuba.load({ action: '#{CGI.escape(entry.interface).gsub('%2F','/').gsub('%3D','=')}' }); "
          next_level = Accordion_Box.new(:header => HTML.a(:onclick => onclick) { e.model_instance.label }, :class => "accordion_level_#{indent}") { recurse(entry_id, indent+1) }.string
          string << next_level.string
        else
          label_string = decorate_entry(e)
          string << HTML.div { label_string }.string if label_string
        end
      end
      return string
    end

  end # }}}

  class Hierarchy_Entries_Sortable_Decorator < Hierarchy_Entries_Default_Decorator
  # {{{
    def initialize(hierarchy_map)
      super(hierarchy_map) 
    end
    def recurse(parent_id, indent=1)
      return '' unless @entry_map[parent_id] 
      string = ''
      for e in @entry_map[parent_id] do
      # entry = plugin_get(Hook.main.hierarchy.sortable_entry_decorator, :entry => e)
        entry_id = e.model_instance.pkey_value
        
        label_string = decorate_entry(e)

        if @entry_map[entry_id] then
          next_level = recurse(entry_id, indent+1) 
        else
          next_level = ''
        end
        string << HTML.li(:id => 'entry_' << entry_id) { HTML.font(:style => 'cursor: ns-resize; ') { label_string } +
                   HTML.ul(:id => "entry_placeholder_#{entry_id}", :class => 'no_bullets drop-placeholder') { '&nbsp;' + 
                       next_level 
                   }
                  }.string
      end
      return string
    end

    def decorate_entry(e)
      e.model_instance.label
    end

  end # }}}
 
  class Hierarchy_Default_Decorator
  # {{{
  extend Aurita::GUI
  include Aurita::GUI

    attr_reader :string, :entries_string
    attr_accessor :entry_decorator, :dom_id, :context_menu_params, :header, :context_menu_model
    
    @entries_string

  protected
    @string
    @hierarchy
    @entry_model

  public

    def initialize(hierarchy_map)
      @context_menu_model = ''
      @hierarchy = hierarchy_map
      @string = ''
      @entry_model = @hierarchy.entry_model
      @entry_decorator = Hierarchy_Entries_Default_Decorator
      @entries_string = ''
      build()
    end

    def build()
      @entries_string = @entry_decorator.new(@hierarchy).string
      box = Box.new(:entity => @hierarchy, 
                    :class => :topic, 
                    :id => @dom_id.to_s)
      box.header = @header.to_s
      begin
        box.body = Aurita::Main::App_Controller.view_string(:hierarchy, :entries => @entries_string)
        @string = box.string
      rescue ::Exception => e
      end
    end

  end # }}}

  class Hierarchy_Sortable_Decorator < Hierarchy_Default_Decorator
  # {{{

    attr_reader :string, :entries_string

    @entries_string = ''
    
    def initialize(hierarchy, model)
      @hierarchy = hierarchy
      @string = ''
      @entry_model = model
      @entries_string = Hierarchy_Entries_Sortable_Decorator.new(model).string
      build()
    end
    def render
      js = "reorder_hierarchy_id=#{@hierarchy.hierarchy_id}; 
            Sortable.create('hierarchy_sortable_list_#{@hierarchy.hierarchy_id}', 
                            { onUpdate: on_hierarchy_entry_reorder, tree: true });"
      hid = @hierarchy.hierarchy_id
      icon = HTML.img(:src => '/aurita/images/icons/save.gif', 
                      :style => 'margin-bottom: 4px;', 
                      :onclick => "Cuba.load({ element: 'hierarchy_#{hid}_body', action: 'Hierarchy/body/hierarchy_id=#{hid}' }); " )
      App_Controller.render_string(:html => icon + @entries_string, 
                                   :script => js)
    end
  end # }}}

  class Hierarchy_Accordion_Decorator < Hierarchy_Default_Decorator
  # {{{
  extend Aurita::GUI
  include Aurita::GUI

    attr_reader :string, :entries_string
    attr_accessor :entry_decorator, :dom_id, :context_menu_params, :header, :context_menu_model
    
    @entries_string

  protected
    @string
    @hierarchy
    @entry_model

  public

    def initialize(hierarchy_map)
      @context_menu_model = ''
      @hierarchy = hierarchy_map
      @string = ''
      @entry_model = @hierarchy.entry_model
      @entry_decorator = Hierarchy_Entries_Accordion_Decorator
      @entries_string = ''
      build()
    end

    def build()
      @entries_string = @entry_decorator.new(@hierarchy).string
      box = Box.new(:entity => @hierarchy, 
                    :class => :topic, 
                    :id => @dom_id.to_s)
      box.header = @header.to_s
      begin
        box.body = @entries_string
        @string = box.string
      rescue ::Exception => e
      end
    end
  end # }}} 

end
end

