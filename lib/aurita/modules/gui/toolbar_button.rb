
require('aurita')
require('aurita-gui/element')
Aurita.import_module :gui, :icon
Aurita.import_module :gui, :link_helpers

module Aurita
module GUI

  class Toolbar_Button < Element
    include Link_Helpers

    attr_accessor :icon, :label, :action

    def initialize(params)
      @tag    = :a
      @icon   = params[:icon]
      @label  = params[:label]
      @action = params[:action]
      super()
    end

    def string
      HTML.a(:class   => :toolbar_button, 
             :onclick => link_to(:action => @action)) { 
        Icon.new(@icon).string + HTML.div.label { @label }.string
      }.string
    end

  end

end
end

