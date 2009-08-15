
require('aurita-gui/widget')

module Aurita
module GUI

  class Async_Form_Decorator < Widget
  include Aurita::GUI::I18N_Helpers

    attr_accessor :form

    def initialize(form)
      @form = form
      form.enctype  = 'multipart/form-data'
      form.method   = 'POST'
      form.onsubmit = 'Aurita.submit_form(this); return false;' unless form.onsubmit
      super()
    end
    def element
      HTML.div.form_box { 
        HTML.div.form_content { @form } + 
        HTML.div.form_button_bar(:id => @form.dom_id + '_buttons')  {
          Button.new(:class => :submit, :onclick => Javascript.Aurita.submit_form(@form.dom_id.to_s), :icon => :ok) { tl(:ok) } + 
          Button.new(:class => :cancel, :onclick => Javascript.Aurita.cancel_form(@form.dom_id.to_s), :icon => :cancel) { tl(:cancel) } 
        }
      }
    end
  end

end
end

