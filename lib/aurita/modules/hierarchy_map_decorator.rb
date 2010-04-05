
Aurita.import_module :hierarchy_map

module Aurita
module GUI

  class Hierarchy_Map_Decorator

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

    def render_tree(top_id=0, &block)
      return false unless entries[top_id]
      entries[top_id].map { |e|
        block.call(e, render_tree(e.pkey, &block))
      }
    end

  end

end
end

