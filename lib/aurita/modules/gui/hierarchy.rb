
require('aurita/controller')
require('cgi')
Aurita.import_module :gui, :module
Aurita.import_module :gui, :box
Aurita.import_module :hierarchy_map

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
      
      entry_idx = 0
      for e in @entry_map[parent_id] do

        entry_id   = e.pkey
        next_level = []
        if @entry_map[entry_id].length > 0 then
          next_level = decorate_level(e, recurse(entry_id, indent+1))
          next_level.add_css_class("indent-#{indent}")
        end
        entry = decorate_entry(e, next_level, indent, entry_idx)
        if entry then
          elements << entry 
          entry_idx += 1
        end
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
              action = CGI.escape(e.interface).gsub('%2F','/').gsub('%3D','=')
              entry  = link_to(:action => action) { e.label }
            end
          end
        end
      end
      entry = HTML.div { entry } if entry.kind_of?(String)
      entry
    end

    # Overload method decorate_entry to support other 
    # model instances for hierarchies
    def decorate_entry(e, next_level, indent, entry_idx=0)
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
      entry  = Context_Menu_Element.new(:entity => e, 
                                        :params => params) { 
        HTML.div { entry }
      }

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
      @entry_map    = hierarchy_map
      @group_class  = params[:group_class]
      @dom_id       = 'accordion_hierarchy'
      @context_menu = params[:context_menu] != false
      super(hierarchy_map)
    end

    def decorate_entry(entry, child_elements, indent, entry_idx=0)
      d_entry = nil
      if child_elements.length > 0 then
        onclick = link_to(Content.get(entry.content_id).concrete_instance) if entry.content_id
        dom_id  = "hierarchy_#{entry.hierarchy_id}_#{entry.pkey}"
        box     = Accordion_Box.new(:entity  => entry, 
                                    :level   => indent, 
                                    :onclick => onclick, 
                                    :id      => dom_id)
        box.header = entry.label 
        box.body   = child_elements
        d_entry = box
      else
        item = decorate_item(entry, indent)
        if @context_menu then
          params = { :hierarchy_entry_id => entry.hierarchy_entry_id, 
                     :hierarchy_id       => entry.hierarchy_id }
          item  = Context_Menu_Element.new(:entity => entry, 
                                           :params => params) { 
            item
          }
        end
        d_entry = item 
      end
      HTML.div(:class => [ :accordion_item, "accordion_item_#{entry_idx}" ]) { d_entry }
    end

    def element
      recurse(0)
    end

  end # }}}

  class Hierarchy_Entries_Sortable_Decorator < Hierarchy_Entries_Default_Decorator
  # {{{
    def initialize(hierarchy_map)
      @sortable_dom_id = "hierarchy_sortable_list_#{hierarchy_map.hierarchy.hierarchy_id}"
      super(hierarchy_map) 
    end

    def recurse(parent_id, indent=1)
      return '' unless @entry_map[parent_id] 
      elements = []
      for e in @entry_map[parent_id] do
        entry_id = e.pkey_value
        
        if @entry_map[entry_id] then
          next_level = recurse(entry_id, indent+1) 
        else
          next_level = ''
        end

        entry = decorate_entry(e, next_level, indent)

        elements << HTML.li(:id => "entry_#{entry_id}") { 
          HTML.font(:style => 'cursor: ns-resize; ') { entry } +
          HTML.ul(:id    => "entry_placeholder_#{entry_id}", 
                  :class => 'no_bullets drop-placeholder') { 
            '&nbsp;' + next_level 
          }
        }
      end
      return elements
    end

    def element
      @elements ||= recurse(0)
      return HTML.ul(:class => [ :outer, :no_bullets ], 
                     :id    => @sortable_dom_id ) { 
        @elements
      }
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
      box        = Box.new(:entity => @hierarchy, 
                           :class  => :topic, 
                           :id     => dom_id().to_s)
      box.header = @header.to_s
      box.body   = @entry_decorator.new(@hierarchy_map)
      box.rebuild
      return box
    end

  end # }}}

  class Hierarchy_Sortable_Decorator < Hierarchy_Default_Decorator
  # {{{
    
    def initialize(hierarchy_map)
      @entry_decorator = Hierarchy_Entries_Sortable_Decorator
      super(hierarchy_map)
      @dom_id = "hierarchy_sortable_list_#{@hierarchy.hierarchy_id}"
    end
    
    def js_initialize
      "reorder_hierarchy_id=#{@hierarchy.hierarchy_id}; 
       Sortable.create('#{@dom_id}', 
                       { onUpdate: Aurita.GUI.on_hierarchy_entry_reorder, tree: true });"
    end

    def element
      hid  = @hierarchy.hierarchy_id
      icon = HTML.img(:src     => '/aurita/images/icons/save.gif', 
                      :style   => 'margin-bottom: 4px;', 
                      :onclick => "Aurita.load({ element: '#{@dom_id}_body', 
                                                 action: 'Hierarchy/body/hierarchy_id=#{hid}' 
                                              });")
      HTML.div { 
        icon + @entry_decorator.new(@hierarchy_map)
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

