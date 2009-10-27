
require('aurita-gui/widget')

module Aurita
module GUI

  class Hierarchy_Node_Select_Entry < Aurita::GUI::Select_Field
    def initialize(params={}, &block)
      @level = params[:level].to_i
      if params[:entities] then
        params[:option_values] = []
        params[:option_labels] = []
        params[:entities].each { |e|
          params[:option_values] << e.pkey
          params[:option_labels] << e.label
        }
      end
      params.delete(:level)
      params.delete(:entities)
      @real_attribute_name = params[:name]
      params[:name] = "#{params[:name]}_level_#{@level}"
      super(params, &block)
    end

    def element
      return HTML.div unless @option_values.length > 0
      
      @option_labels = [ '-- Unterordner-- '] + @option_labels
      @option_values = [ '' ] + @option_values
      
      @option_labels.map! { |l|
        label = ''
        @level.to_i.times { label << '&nbsp;' }
        label << l
      }
      @attrib[:label] = label
      field = super()
      field.onchange = "Aurita.hierarchy_node_select_onchange(this, '#{@real_attribute_name}', #{@level})"
      return HTML.div { field + HTML.div(:id => "#{@real_attribute_name}_#{@level}_next") }
    end
  end
  
  # Usage: 
  #
  #   hns = Hierarchy_Node_Select_Field.new(:name => :the_node, :value => 123) 
  #   hns.field_type = My_Option_Field_Class # default: Select_Field
  #
  class Hierarchy_Node_Select_Field < Aurita::GUI::Form_Field
    
    attr_accessor :field_type, :model
    
    def initialize(params={}, &block) 
      @entry_type = Hierarchy_Node_Select_Entry
      @value      = params[:value]
      @model      = params[:model]
      @model    ||= Aurita::Plugins::Wiki::Media_Asset_Folder
      super(params, &block)
    end
    
    def element
      result   = Array.new
      levels   = reverse_node_map(@value) if @value
      levels ||= []
      levels.each_with_index { |level, idx|
        field = @entry_type.new(:name          => @attrib[:name],
                                :class         => [ :hierarchy_node_select, "hierarchy_level_#{idx}" ], 
                                :option_values => level[:option_values], 
                                :option_labels => level[:option_labels],  
                                :level         => idx, 
                                :value         => level[:value])
        inject_element = result
        while inject_element[-1] do
          inject_element = inject_element[-1]
        end
        inject_element << field.element if inject_element
      }
      
      return HTML.div.hierarchy_node_select { 
        Hidden_Field.new(:id    => @attrib[:name], 
                         :name  => @attrib[:name], 
                         :value => @value) + result 
      }
    end
    
    def readonly_element
      HTML.div { @value } 
    end
    
  protected

    # Returns parent node ids of given node id. 
    # Example: 
    # 
    #   1 -> 34 -> 123
    # -->
    #   reverse_node_map(123) 
    # --> 
    #   [ 
    #     { :option_values => [1,4,6],       :option_labels => [:first, :second, :third], :value => 1 }, 
    #     { :option_values => [33,34,35],    :option_labels => [:first, :second, :third], :value => 34 }, 
    #     { :option_values => [121,122,123], :option_labels => [:first, :second, :third], :value => 123 }
    #   }
    #
    def reverse_node_map(node_id)
      levels = []
      e      = @model.get(node_id)

      STDERR.puts "e: #{e}"

      return [] unless e

      children = e.child_nodes 

      STDERR.puts "c: #{children.inspect}"
      if children then
        values = []
        labels = []
        children.each { |c|
          values << c.key.values.first
          labels << c.label
        }
        levels << { :option_values => values, 
                    :option_labels => labels }
      end
      while e do
        node_id = e.key.values.first
        values = []
        labels = []
        @model.children_of(e.parent_id).each { |c|
          values << c.key.values.first
          labels << c.label
        }
        levels << { :option_values => values, 
                    :option_labels => labels, 
                    :value => node_id }

        # Next level: 
        e = e.parent_node
      end
      return levels.reverse
    end

  end

end
end
