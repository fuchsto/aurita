
require('aurita-gui/widget')
require('json')
Aurita.import_module :gui, :icon
Aurita.import_module :gui, :link_helpers


module Aurita
module GUI

  class Toggle_Button < Widget
  include Aurita::GUI::Link_Helpers

    def initialize(params={})
      @params       = params
      @modes      ||= {}
      @mode_names ||= []
      @active_mode  = false
      @next_mode    = false
      @dom_id       = params[:id]

      super()
    end

    def add_mode(mode_name, params={})
      @mode_names << mode_name
      @modes[mode_name] = params
      rebuild
    end
    alias set_mode add_mode

    def active_mode
      @active_mode || @mode_names.first
    end

    def active_mode=(mode)
      @active_mode = mode
      @next_mode   = @mode_names.select { |n| n.to_s != @active_mode.to_s }.first
      rebuild
      return mode
    end

    def element
      mode = @modes[@next_mode]
      return HTML.div(:id  => @dom_id) { } unless mode
      icon = HTML.img(:src => "/aurita/images/icons/#{mode[:icon]}") 
      icon.onclick = "Aurita.GUI.Toggle_Button.toggle({ button: '#{@dom_id}' });"
      
      HTML.div(:id => @dom_id) {
        icon
      }
    end

    def js_initialize
<<CODE
      Aurita.GUI.Toggle_Button.register_button({ button: '#{@dom_id}', 
                                                 modes: #{@modes.to_json}, 
                                                 next_mode: '#{@next_mode}', 
                                                 active_mode: '#{active_mode}' });
CODE
    end

  end

end
end

