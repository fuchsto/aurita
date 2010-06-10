
require('aurita')
require('aurita-gui')
require('aurita-gui/widget')

Aurita.import_module :gui, :i18n_helpers
Aurita.import_module :gui, :entity_select_field

module Aurita
module GUI

  class Entity_Selection_List_Field < Selection_List_Field
  include Aurita::GUI::I18N_Helpers

    attr_reader :entities

    class Entity_Selection_List_Option_Field < Selection_List_Option_Field
      def initialize(params={})
        super(params)
      end
      def element
        HTML.div { 
          Hidden_Field.new(:name => "#{@attrib[:name]}[]", :value => @value) + 
          HTML.a(:onclick => "Element.remove('#{@parent.dom_id}');", 
                 :class   => :icon) { 
            HTML.img(:src => '/aurita/images/icons/delete_small.png') 
          } + 
          HTML.span { @label }
        }
      end
    end
    
    # Parameters: 
    #
    # From GUI::Form_Field: 
    # :label
    # :name
    # :value
    #
    # From GUI::Selection_List_Field: 
    # :option_labels
    # :option_values
    #
    # Specific: 
    # :entities, or 
    # :model
    #
    def initialize(params={}, &block)
      @option_field_decorator ||= Entity_Selection_List_Option_Field
      @select_field_class     ||= Entity_Select_Field
      
      @model    ||= params[:model]
      @entities ||= params[:entities]
      
      params[:value] ||= []

      if !@entities then
        @entities = @model.find(:all).entities
      end
      
      option_values  = []
      option_labels  = []
      @entities.each { |e|
        option_values << e.pkey
        option_labels << e.label
      }
      
      option_values = [''] + option_values
      option_labels = [tl(:select_option)] + option_labels
      
      options = option_labels
      begin
        options.fields = option_values.map { |v| v.to_s }
      rescue ::Exception => e
        raise ::Exception.new("Failed arrayfields values: #{option_values.inspect}")
      end

      params.delete(:model)
      params.delete(:entities)

      params[:options] = options

      super(params, &block)
    end

  end

end
end


