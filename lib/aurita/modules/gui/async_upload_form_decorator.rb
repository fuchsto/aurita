
require('aurita-gui/widget')

module Aurita
module GUI

  class Async_Upload_Form_Decorator < Widget
  include Aurita::GUI::I18N_Helpers

    attr_accessor :form, :label_ok, :label_cancel, :icon

    def initialize(form, params={})
      @form = form

      @label_ok       = params[:label_ok]
      @label_cancel   = params[:label_cancel]
      @button_class   = params[:button_class]
      @button_class ||= Aurita.project.default_form_button_class
      @button_class ||= Text_Button
      @icon_ok        = :ok
      @icon_cance     = :cancel

      raise ::Exception.new("Form instances must have a DOM id. Please provide parameter :id. ") unless @form.dom_id
      
      form.enctype    = 'multipart/form-data'
      form.method     = 'POST'
      form.target     = 'asset_upload_frame' unless form.target
    # form.onsubmit   = 'Aurita.submit_upload_form(this); return false;' unless form.onsubmit
      @label_ok     ||= tl(:ok)
      @label_cancel ||= tl(:cancel)
      @buttons        = params[:buttons]
      @buttons      ||= Proc.new { |btn_params|
        @button_class.new(:class   => :submit, 
                          :onclick => btn_params[:onclick_ok].to_s, 
                          :icon    => :ok, 
                          :label   => btn_params[:label_ok].to_s).string 
      }
      super()
    end
    def element
      buttons = @buttons.call(:onclick_ok     => Javascript.Aurita.submit_upload_form(@form.dom_id.to_s), 
                              :onclick_cancel => '',
                              :label_ok       => @label_ok, 
                              :label_cancel   => @label_cancel) 
      HTML.div.form_box { 
        HTML.div.form_content { @form } + 
        HTML.div.form_button_bar(:id => "#{@form.dom_id}_buttons")  {
          buttons
        }
      }
    end
  end

end
end

