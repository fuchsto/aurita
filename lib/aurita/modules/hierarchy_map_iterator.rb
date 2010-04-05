
Aurita.import_module :hierarchy_map

module Aurita
module GUI

  # Iterate over a hierarchy map instance by passing a 
  # block. 
  # Example for a simple tree view using HTML lists: 
  #
  #   dec  = Hierarchy_Map_Iterator.new(array_or_hierarchy_map)
  #   list = dec.map_recursive { |entry, children, tree_level|
  #     entry  = HTML.li.list { entry } 
  #     entry += HTML.ul.list { children } if subs
  #     entry.add_css_class("level_#{tree_level}")
  #     entry
  #   }
  # 
  #   list = HTML.ul.tree { list }
  #
  class Hierarchy_Map_Iterator

    attr_accessor :map

    def initialize(hierarchy_map, &block)
      if hierarchy_map.is_a?(Array) then
        @map = Hierarchy_Map.new(hierarchy_map)
      else
        @map = hierarchy_map
      end
      @block   = false
      @block   = block if block_given?
      @entries = false
    end

    def entries
      return @entries if @entries
      if @block then
        @entries = {}
        @map.entries.each_pair { |parent_id, e|
          @entries[parent_id] ||= []
          @entries[parent_id]   = @block.call(e)
        }
      else
        @entries = @map.entries
      end
      return @entries
    end

    def each(&block)
      entries.each(&block)
    end
    def map(&block)
      entries.map(&block)
    end

    def each_with_level(top_id=0, level=0, &block)
      return false unless entries[top_id]
      entries[top_id].each { |e|
        block.call(e, level)
        each_with_level(e.pkey, level+1, &block)
      }
    end

    def map_recursive(top_id=0, level=0, &block)
      return false unless entries[top_id]
      entries[top_id].map { |e|
        block.call(e, map_recursive(e.pkey, level+1, &block), level)
      }
    end

  end

end
end

