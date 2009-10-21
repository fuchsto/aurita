
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
  class Async_Form_Decorator < Widget
  include Aurita::GUI::I18N_Helpers

    attr_accessor :form

    def initialize(form, params={})
      @form   = form
      @params = {}
      @params[:header] = @params[:title] unless @params[:header]
      @form.enctype  = 'multipart/form-data'
      @form.method   = 'POST'
      @form.onsubmit = 'Aurita.submit_form(this); return false;' unless form.onsubmit
      super()
    end
    def element
      form_box = HTML.div.form_box { 
        HTML.div.form_content { @form } + 
        HTML.div.form_button_bar(:id => "#{@form.dom_id}_buttons")  {
          Text_Button.new(:class   => :submit, 
                          :onclick => Javascript.Aurita.submit_form(@form.dom_id.to_s), 
                          :icon    => 'button_ok.gif', 
                          :label   => tl(:ok)).string +
          Text_Button.new(:class   => :cancel, 
                          :onclick => Javascript.Aurita.cancel_form(@form.dom_id.to_s), 
                          :icon    => 'button_cancel.gif', 
                          :label   => tl(:cancel)).string
        }
      }
      if @params[:header] then
        Page.new(@params) { form_box }
      else
        form_box
      end
    end
  end

end
end

