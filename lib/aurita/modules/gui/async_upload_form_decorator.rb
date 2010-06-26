
require('aurita-gui/widget')

module Aurita
module GUI

  class Async_Upload_Form_Decorator < Widget
  include Aurita::GUI::I18N_Helpers

    attr_accessor :form

    def initialize(form)
      @form = form
      raise ::Exception.new("Form instances must have a DOM id. Please provide parameter :id. ") unless @form.dom_id
      form.enctype  = 'multipart/form-data'
      form.method   = 'POST'
      form.target   = 'asset_upload_frame' unless form.target
    # form.onsubmit = 'Aurita.submit_upload_form(this); return false;' unless form.onsubmit
      super()
    end
    def element
      HTML.div.form_box { 
        HTML.div.form_content { @form } + 
        HTML.div.form_button_bar(:id => "#{@form.dom_id}_buttons")  {
          Text_Button.new(:class   => :submit, 
                          :onclick => Javascript.Aurita.submit_upload_form(@form.dom_id.to_s), 
                          :icon    => :ok, 
                          :label   =>  tl(:ok)).string 
        }
      }
    end
  end

end
end

