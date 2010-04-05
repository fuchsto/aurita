
module Aurita

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

    attr_reader :entry_map, :entry_model, :hierarchy, :entities
    
    def initialize(entities)
      @entities    = entities
      @entries     = false
      @hierarchy   = @entities.first.hierarchy if @entities.first
      @entry_model = @entities.first.class if @entities.first
    end

    def entries
      return @entries if @entries
      @entries = {}
      @entities.each { |entry|
        pid = entry.parent_id # Has to be provided by model instance
        @entries[pid] ||= []
        @entries[pid]  << entry
      }
      return @entries 
    end

    def set_entries(*entries)
      entries = entries.flatten
      if !entries.first.respond_to?(:parent_id) then
        raise InvalidArgumentException.new("Entries have to provide method #parent_id")
      end
      @entities = entries
      @entries  = false
      return true
    end
    alias entities= set_entries
    alias entries= set_entries

    def add_entry(entry)
      if !entry.respond_to?(:parent_id) then
        raise InvalidArgumentException.new("Entries have to provide method #parent_id")
      end
      @entities << entry
      @entries = false
      return true
    end

    def [](key)
      entries[key] || []
    end
    
  end 


end # module Aurita


