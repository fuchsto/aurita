
require('aurita-gui/element')

module Aurita
module GUI

  class Form_Field_Hint < Element

    def initialize(form_field, params={})
      @field           = form_field
      params[:tag]     = :div
      params[:id]      = "#{@field.dom_id}_hint"
      params[:class]   = :hint
      params[:content] = hint_box()
      super(params)
    end

    def hint_box
      HTML.div.top { 
        HTML.div.middle { 
          HTML.div.hint_text { @field.hint } 
        } + 
        HTML.div.bottom { }
      }
    end

  end

end
end

