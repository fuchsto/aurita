
require('aurita')
require('aurita-gui/widget')
Aurita.import_module :gui, :link_helpers

module Aurita
module GUI

  class User_Icon < Aurita::GUI::Widget
  include Aurita::GUI::Link_Helpers

    def initialize(user, params={})
      @entity = user
      @size   = params[:size]
      params.delete(:size)
      @css_classes = params[:class]
      @css_classes = [ @css_classes ] unless @css_classes.is_a?(Array)
      params.delete(:class)
      super()
    end
  
    def element
      HTML.div(:class => [:user_icon, @size] << @css_classes) { 
        HTML.div.image { 
          link_to(@entity) { 
            HTML.img(:src => "/aurita/assets/#{@size}/asset_#{@entity.picture_asset_id}.jpg")
          }
        } + 
        HTML.div.info { 
          link_to(@entity) { @entity.user_group_name }
        }
      }
    end

  end

end
end
