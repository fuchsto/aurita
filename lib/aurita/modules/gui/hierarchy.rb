
require('aurita/controller')
require('cgi')
Aurita.import_module :gui, :module
Aurita.import_module :gui, :box

module Aurita
module GUI

  # Default decorator for a single Hierarchy_Entry element. 
  #
  # Usage: 
  #
  #   entry   = Hierarchy_Entry.get(123)
  #   element = Hierarchy_Element.new(entry)
  #   element.id      = 'my_element'
  #   element.onclick = "alert('Clicked my element');"
  #   puts element.string
  #
  # Model instance 'entry' has to include behaviour "Aurita::GUI::Hierarchy_Element_Behaviour"
  #
  class Hierarchy_Element < Element
    attr_accessor :entity, :label, :onclick, :class

    def initialize(entity)
      @tag     = :li
      @entity  = entity
      @class   = 'hierarchy_entry'
      @label   = entity.entry_label.to_s
      @id      = entity.entry_key.to_s
      @onclick = nil
      @icon    = false
      @string  = false
    end
    def string
      params    = { :class => @class, :onclick => @onclick } 
      @icon   ||= :blank
      @string   = HTML.li(entry_params) { "<img src=\"/aurita/images/icons/#{@icon}.gif\" /> #{@label}" }
      return @string
    end

    def inspect
      string()
    end
  end

  # Distributes flat list of hierarchy entries to a Hash so
  # they are mapped to their parent entry id. 
  #
  # Usage: 
  #
  #   entries = Hierarchy.get(123).entries 
  #
  # Hierarchy#entries returns Hierarchy_Entry instances ordered 
  # by position, but not mapped to parents. 
  #
  #   map     = Hierarchy_Map.new(entries)
  #
  # Using Hierarchy_Map, they can now be accessed by their parent id: 
  #
  #   map[0]  # All entries with parent_id = 0
  #   --> [ Hierarchy_Entry(1), Hierarchy_Entry(2) ]
  #
  #   map[1]  # All entries with parent_id = 1
  #   --> [ Hierarchy_Entry(10), Hierarchy_Entry(20) ]
  #
  #   map[2]  # All entries with parent_id = 2
  #   --> []
  # 
  class Hierarchy_Map
  # {{{

    attr_reader :entry_map, :entry_model, :hierarchy
    
    def initialize(entities)
      @entities    = entities
      @entries     = false
      @hierarchy   = @entities.first.hierarchy if @entities.first
      @entry_model = @entities.first.class if @entities.first
    end

    def entries
      if !@entries then
        @entries = {}
        @entities.each { |entry|
          pid = entry.parent_id # Has to be provided by model instance
          @entries[pid]  = Array.new unless @entries[pid]
          @entries[pid] << entry
        }
      end
      return @entries
    end

    def [](key)
      entries[key] || []
    end
    
  end # }}}

  class Hierarchy_Entries_Default_Decorator < Widget
  # {{{
  extend Aurita::GUI::Helpers
  include Aurita::GUI::Helpers
  include Aurita::GUI

  public
  
    element_properties :dom_id
  
    def initialize(hierarchy_map)
      @entry_map       ||= hierarchy_map
      @dom_id          ||= 'hierarchy_entries'
      @entry_decorator ||= Hierarchy_Element
      @elements          = false
      super()
    end

    def recurse(parent_id, indent=1)
      return [] unless @entry_map[parent_id] 
      elements = []
      for e in @entry_map[parent_id] do

        entry_id   = e.pkey
        next_level = []
        if @entry_map[entry_id].length > 0 then
          next_level = decorate_level(e, recurse(entry_id, indent+1))
          next_level.add_css_class("indent-#{indent}")
        end
        entry = decorate_entry(e, next_level, indent)
        elements << entry if entry 
      end
      return elements
    end

    def decorate_level(parent, child_elements)
      HTML.ul(:class => "no_bullets") { child_elements }
    end

    def decorate_item(e, indent)
      entry = e.label
      if e.attr[:entry_type] != 'BLANK_NODE' then
        if e.content_id then
          onclick = link_to(Content.get(e.content_id).concrete_instance) 
          entry   = HTML.a(:onclick => onclick) { e.label } 
        else
          if e.interface then
            if e.interface.include?('://') then
              entry  = HTML.a(:href => e.interface, :target => '_blank') { e.label }
            else 
              action = CGI.escape(interface).gsub('%2F','/').gsub('%3D','=')
              entry  = link_to(:action => action) { e.label }
            end
          end
        end
      end
      entry
    end

    # Overload method decorate_entry to support other 
    # model instances for hierarchies
    def decorate_entry(e, next_level, indent)
      entry = decorate_item(e, indent)

#     if !e.allow_access?(Aurita.user) then
#       if Aurita.user.is_registered? then
#         return HTML.span.not_accessible { entry } 
#       else
#         return nil
#       end
#     end

      params = { :hierarchy_entry_id => e.hierarchy_entry_id, 
                 :hierarchy_id       => e.hierarchy_id }
    # entry  = Context_Menu_Element.new(:entity => e, 
    #                                   :params => params) { 
    #   HTML.div.link { entry.string }
    # }

      return HTML.li { entry + next_level }
    end

    def element
      @elements ||= recurse(0)
      return HTML.ul(:class => :no_bullets, 
                     :id    => @dom_id.to_s ) { 
        @elements
      }
    end

  end # }}}

  class Hierarchy_Entries_Accordion_Decorator < Hierarchy_Entries_Default_Decorator
  # {{{
  extend Aurita::GUI::Helpers
  include Aurita::GUI::Helpers
  include Aurita::GUI
  
    def initialize(hierarchy_map, params={})
      @entry_map   = hierarchy_map
      @group_class = params[:group_class]
      @dom_id      = 'accordion_hierarchy'
      super(hierarchy_map)
    end

    def decorate_entry(entry, child_elements, indent)
      if child_elements.length > 0 then
        onclick = link_to(Content.get(entry.content_id).concrete_instance) if entry.content_id
        dom_id  = "hierarchy_#{entry.hierarchy_id}_#{entry.pkey}"
        box     = Accordion_Box.new(:entity  => entry, 
                                    :level   => indent, 
                                    :onclick => onclick, 
                                    :id      => dom_id)
        box.header = entry.label 
        box.body   = child_elements
        box
      else
        HTML.div.accordion_item { decorate_item(entry, indent) }
      end
    end

    def element
      recurse(0)
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
        entry_id = e.pkey_value
        
        label_string = decorate_entry(e)

        if @entry_map[entry_id] then
          next_level = recurse(entry_id, indent+1) 
        else
          next_level = ''
        end
        string << HTML.li(:id => "entry_#{entry_id}") { HTML.font(:style => 'cursor: ns-resize; ') { label_string } +
                   HTML.ul(:id => "entry_placeholder_#{entry_id}", :class => 'no_bullets drop-placeholder') { 
                     '&nbsp;' + next_level 
                   }
                  }.string
      end
      return string
    end

    def decorate_entry(e, next_level, indent)
      e.label
    end

  end # }}}
 
  class Hierarchy_Default_Decorator < Widget
  # {{{
  extend Aurita::GUI
  include Aurita::GUI

    attr_accessor :entry_decorator, :dom_id, :header

    def initialize(hierarchy_map)
      @hierarchy_map    ||= hierarchy_map
      @hierarchy        ||= hierarchy_map.hierarchy
      @entry_model      ||= @hierarchy.entry_model
      @entry_decorator  ||= Hierarchy_Entries_Default_Decorator
      @dom_id           ||= "hierarchy_#{@hierarchy.pkey}"
      @header           ||= @hierarchy.header
      @entries          ||= false
      super()
    end

    def element
      @entries ||= @entry_decorator.new(@hierarchy_map)
      box = Box.new(:entity => @hierarchy, 
                    :class  => :topic, 
                    :id     => dom_id().to_s)
      box.header = @header.to_s
      box.body   = @entries
      box.rebuild
      return box
    end

  end # }}}

  class Hierarchy_Sortable_Decorator < Hierarchy_Default_Decorator
  # {{{

    attr_reader :string, :entries_string
    
    def initialize(hierarchy, model)
      @entry_model = model
      @entries     = Hierarchy_Entries_Sortable_Decorator.new(model)
      super(hierarchy)
    end
    
    def js_initialize
      "reorder_hierarchy_id=#{@hierarchy.hierarchy_id}; 
       Sortable.create('hierarchy_sortable_list_#{@hierarchy.hierarchy_id}', 
                       { onUpdate: on_hierarchy_entry_reorder, tree: true });"
    end

    def element
      hid  = @hierarchy.hierarchy_id
      icon = HTML.img(:src     => '/aurita/images/icons/save.gif', 
                      :style   => 'margin-bottom: 4px;', 
                      :onclick => "Aurita.load({ element: 'hierarchy_#{hid}_body', 
                                                 action: 'Hierarchy/body/hierarchy_id=#{hid}' 
                                               });")
      HTML.div { 
        icon + @entries
      }
    end
  end # }}}

  class Hierarchy_Accordion_Decorator < Hierarchy_Default_Decorator
  # {{{
  extend Aurita::GUI
  include Aurita::GUI

    def initialize(hierarchy_map)
      @entry_decorator = Hierarchy_Entries_Accordion_Decorator
      super(hierarchy_map)
    end

    def element
      @entries ||= @entry_decorator.new(@hierarchy_map)
      box = Accordion_Box.new(:entity => @hierarchy, 
                              :class  => :topic, 
                              :id     => dom_id().to_s)
      box.header = @header.to_s
      box.body   = @entries
      return box
    end

  end # }}} 

end
end

