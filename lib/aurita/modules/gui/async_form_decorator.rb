
require('aurita-gui/widget')
Aurita.import_module :gui, :page

module Aurita
module GUI

  # Default decorator for Ajax forms in Aurita. 
  # Example usage in controller: 
  #
  #    form     = add_form()
  #    form_box = GUI::Async_Form_Decorator.new(form)
  #
  # In case parameter :header or :title is present, a 
  # GUI::Page instance is returned, wrapping the decorated 
  # form. All optional parameters are then passed to 
  # the constructor of GUI::Page. 
  # Example: 
  #
  #    form     = add_form()
  #    page     = GUI::Async_Form_Decorator.new(form, :header => tl(:add_something), 
  #                                                   :tools  => HTML.div { 'button here' })
  #
  # Note that there are helper methods defined for this 
  # decorator in Controller_Methods. 
  #
  # Form buttons can be defined manually by passing a Proc object rendering them. 
  # The form decorator will pass a parameter hash into this Proc, like: 
  #
  #   { 
  #     :onclick_ok     => "alert('clicked ok');", 
  #     :onclick_cancel => "alert('clicked cancel');", 
  #     :label_ok       => "ok", 
  #     :label_cancel   => "cancel" 
  #   }
  #
  # So, custom form buttons are set like this (in a controller): 
  #
  #   decorate_form(my_form, 
  #                 :buttons => Proc.new { |params|
  #                   Text_Button.new(:onclick => "alert('clicked my button');", 
  #                                   :label   => "click me") + 
  #                   Text_Button.new(:onclick => "alert('clicked my other button');", 
  #                                   :label   => "click me too") + 
  #                 })
  #
  class Async_Form_Decorator < Widget
  include Aurita::GUI::I18N_Helpers

    attr_accessor :form

    def initialize(form, params={})
      @form             = form
      @params           = params
      @params[:header]  = @params[:title] unless @params[:header]
      @form.enctype     = 'multipart/form-data'
      @form.method      = 'POST'
      @form.onsubmit    = 'Aurita.submit_form(this); return false;' unless form.onsubmit
      @onclick_ok       = params[:onclick_ok] 
      @onclick_ok     ||= Javascript.Aurita.submit_form(@form.dom_id.to_s, { :hide_on_submit => @form.hide_on_submit }) 
      @onclick_cancel   = params[:onclick_cancel] 
      @onclick_cancel ||= Javascript.Aurita.cancel_form(@form.dom_id.to_s) 
      @label_ok         = tl(:ok)
      @label_cancel     = tl(:cancel)
      @button_class     = params[:button_class]
      @button_class   ||= Aurita.project.default_form_button_class
      @button_class   ||= Text_Button
      @buttons          = params[:buttons]
      @buttons        ||= Proc.new { |btn_params|
        @button_class.new(:class   => :submit, 
                          :onclick => btn_params[:onclick_ok].to_s, 
                          :icon    => :ok, 
                          :label   => btn_params[:label_ok].to_s).string + 
        @button_class.new(:class   => :cancel, 
                          :onclick => btn_params[:onclick_cancel].to_s, 
                          :icon    => :cancel, 
                          :label   => btn_params[:label_cancel].to_s).string
      }
      super()
    end

    def element
      buttons = @buttons.call(:onclick_ok     => @onclick_ok, 
                              :onclick_cancel => @onclick_cancel, 
                              :label_ok       => @label_ok, 
                              :label_cancel   => @label_cancel) 
      form_box = HTML.div.form_box { 
        HTML.div.form_content { @form } + 
        HTML.div.form_button_bar(:id => "#{@form.dom_id}_buttons") {
          buttons
        }
      }
      if @params[:header] then
        Page.new(@params) { form_box }
      else
        form_box
      end
    end

    def script
      @form.script
    end

  end

end
end

