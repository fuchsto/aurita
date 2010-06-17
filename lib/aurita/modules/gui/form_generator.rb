
require 'rubygems'
require 'aurita'
require 'aurita-gui/form'
require 'aurita-gui/form/form_field_widget'

Aurita.import_module :gui, :custom_form_elements
Aurita.import_module :gui, :form_field_hint

require('lore/gui/form_generator')

module Aurita
module GUI

  class Boolean_Radio_Field < Radio_Field
    # Pre-define
  end

  class Validating_Form_Field_Wrapper < Aurita::GUI::Form_Field_Wrapper
  include Aurita::GUI::I18N_Helpers
    
    def initialize(field)
      if !(field.kind_of? Aurita::GUI::Hidden_Field) then
        field.dom_id = field.name.to_s.gsub('.','_') unless field.dom_id
        data_type    = field.data_type
        data_type  ||= 0
        field.invalid! if (field.value.to_s == '' && field.required?)
        field.onfocus  = "Aurita.form_field_onfocus('#{field.dom_id}');" unless field.onfocus
        field.onblur   = "Aurita.form_field_onblur('#{field.dom_id}'); Aurita.validate_form_field_value(this, #{data_type}, #{field.required?});" unless field.onblur

#       field.onchange = "Aurita.validate_form_field_value(this, #{data_type}, #{field.required?});" unless field.onchange

#       field.hint     = tl("#{field.name.to_s.gsub('.','--')}--hint") unless field.hint
        field.touch
      end
      super(field)
    end

    def decorate_hint(hint)
      Form_Field_Hint.new(@field) 
    end
  end

  class Ajax_Form < Aurita::GUI::Form
    def initialize(params={}, &block)
      super(params, &block)
      @field_decorator = Validating_Form_Field_Wrapper
    end
  end

  class Form_Generator < Lore::GUI::Form_Generator
    include Aurita::GUI
    
    @@type_field_map[Lore::PG_DATE] = Proc.new { |l,f| Aurita::GUI::Datepick_Field.new(:label => l, :name => f) }
    @@type_field_map[Lore::PG_TEXT] = Proc.new { |l,f| Aurita::GUI::Text_Editor_Field.new(:label => l, :name => f) }
    @@type_field_map[Lore::PG_BOOL] = Proc.new { |l,f| Aurita::GUI::Boolean_Radio_Field.new(:label => l, :name => f) }

    def initialize(klass)
      super(klass)
      @form_class = Ajax_Form
    end
  end

end
end

