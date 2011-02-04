
require('aurita-gui/widget')
require('aurita-gui/html')


module Aurita
module GUI

  class Autocompleted_Search_Field < Aurita::GUI::Widget

    # Parameters are: 
    # 
    # - dom_id
    #     Base DOM id for this widget (Default: 'search')
    # - controller
    #     Controller to be called for autocompleted results
    #     Default: 'Autocomplete'
    # - action
    #     Controller action to be called for autocompleted results
    #     Default: 'all'
    # - autocomplete_params
    #     Additional parameters to send to autocompletion controller. 
    #     Default: { :show_all_entry: 0 }
    # - frequency
    #     Poll frequency of autocompletion in Seconds
    #     Default: 0.2
    # - on_result
    #     Javascript callback function for pre-handling 
    #     autocompletion results. 
    #     Default: 'Aurita.GUI.Autocompleted_Search.on_result'
    # - on_result_click
    #     Javascript callback function to be called when 
    #     clicking an autocompletion result. 
    #     Default: 'Aurita.GUI.Autocompleted_Search.on_result_click'
    # - onsubmit
    #     Javascript function to handle submit of search form. 
    #     Default: 'Aurita.submit_form(this); return false;'
    # - submit_controller
    #     Controller to submit search form to.
    #     Default: 'App_Main'
    # - submit_action
    #     Action of submit_controller to submit search form to. 
    #     Default: 'find_full'
    #
    def initialize(params={})
      @dom_id              = params[:dom_id] || :search
      @controller          = params[:controller] ||'Autocomplete'
      @action              = params[:action] || :all
      @frequency           = params[:frequency] || '0.2'
      @on_result           = params[:on_result] || 'Aurita.GUI.Autocompleted_Search.on_result'
      @on_result_click     = params[:on_result_click] || 'Aurita.GUI.Autocompleted_Search.on_result_click'
      @onsubmit            = params[:onsubmit] || "Aurita.submit_form(this, { element: 'app_main_content' }); return false;"
      @submit_controller   = params[:submit_controller] || 'App_Main'
      @submit_action       = params[:submit_action] || 'find_full'
      @autocomplete_params = params[:autocomplete_params] || { :show_all_entry => 0 }
      @params              = params
      super()
    end

    def element
      HTML.form(:method => :POST, :action => '/', :onsubmit => @onsubmit) { 
        HTML.input(:type => :hidden, :name => :controller, :value => @submit_controller) +
        HTML.input(:type => :hidden, :name => :action, :value => @submit_action) +
        
        HTML.div.autocompleted_search_field(:id => @dom_id) { 
          HTML.span.search_indicator_default(:id => "#{@dom_id}_indicator_default") { 
            HTML.img(:src => '/aurita/images/search.gif') 
          } + 
          HTML.span.search_indicator_loading(:id => "#{@dom_id}_indicator_loading") { 
            HTML.img(:src => '/aurita/images/search_loading.gif') 
          } +
          HTML.div.autocomplete_field_wrap { 
            HTML.input(:type => :text, :id => "#{@dom_id}_autocomplete_input", :name => :key, :class => :autocomplete) 
          } +
          HTML.div.autocomplete_choices(:id => "#{@dom_id}_autocomplete_choices")
        }
      }
    end

    def js_initialize
      params = @autocomplete_params.to_get_params
      
      <<JSCODE
      new Ajax.Autocompleter("#{@dom_id}_autocomplete_input", 
                             "#{@dom_id}_autocomplete_choices", 
                             "/aurita/poll", 
                             { 
                               minChars: 2, 
                               updateElement: #{@on_result_click}, 
                               indicator: '#{@dom_id}_indicator_loading', 
                               tokens: [], 
                               frequency: #{@frequency}, 
                               callback: #{@on_result}, 
                               parameters: 'controller=#{@controller}&action=#{@action}&mode=none&#{params}'
                             }
      );
      
JSCODE
    end

  end

end
end

