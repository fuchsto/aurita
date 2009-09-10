
require('rubygems')
require('aurita-gui/widget')
require('aurita-gui/html')
require('aurita-gui/javascript')
require('aurita')
require('aurita/base/session')
Aurita.import_module :gui, :i18n_helpers

module Aurita
module GUI

  # Usage: 
  #  
  #   tab_group = Tab_Group.new(:id => :mailbox
  #                             :tab_headers => [ :inbox, :read, :sent, :trash ], 
  #                             :tab_actions => [ 
  #                               'Messaging::Mailbox/inbox', 
  #                               'Messaging::Mailbox/read', 
  #                               'Messaging::Mailbox/sent', 
  #                               'Messaging::Mailbox/trash' 
  #                             ], 
  #                             :opened => :inbox) {
  #     "initial tab content"
  #   }
  #
  # Passing :tab_headers and :tab_actions as separate arrays assures 
  # tabs will be rendered in correct order. 
  # Internally, these arrays will be combined into an arrayfield 
  # (see documentation on the arrayfield gem). 
  # You can pass a pre-built arrayfield object yourself, like: 
  #
  #   tab_headers = [ :inbox, :read, :sent, :trash ] 
  #   tabs = tab_headers.map { |h| "Messaging::Mailbox/#{h}" }
  #   tabs.fields = tab_headers
  #   tab_group = Tab_Group.new(:tabs => tabs) { "initial tab content" }
  #
  # In case order of tabs is not important, you can also pass them as 
  # hash: 
  #
  #   tab_group = Tab_Group.new(:id => :mailbox
  #                             :tabs => { 
  #                               :inbox => 'Messaging::Mailbox/inbox', 
  #                               :read  => 'Messaging::Mailbox/read', 
  #                               :sent  => 'Messaging::Mailbox/sent', 
  #                               :trash => 'Messaging::Mailbox/trash' 
  #                             }, 
  #                             :opened => :inbox) { 
  #     "initial tab content"
  #   }
  #
  class Tab_Group < Widget
    include I18N_Helpers

    def initialize(params={}, &block)
      @tabs = params[:tabs]
      if !@tabs then
        @tabs        = params[:tab_actions]
        @tabs.fields = params[:tab_headers]
      end
      @opened  = params[:opened]
      @id      = params[:id]
      @content = yield() if block_given?
      super()
    end

    def element
      tabs = []
      @tabs.each_pair { |tab, action|
        tab_id = "#{@id}_tab_#{tab}"
        tab_class = [ tab ]
        tab_class << :active if @opened == tab
        tabs << HTML.div(:id      => tab_id.to_sym, 
                         :onclick => Javascript.Aurita.tab_click(@id, tab_id, tab), 
                         :class   => tab_class) { tl("#{tab_id}") }
      }
      HTML.div(:id => @id) { 
        HTML.div(:id => "#{@id}_tabs") { 
          tabs
        } + 
        HTML.div(:id => "#{@id}_tab_content") { 
          @content
        }
      }
    end

    def js_initialize
    <<JS
      params = { 
        tab_group_id = '#{@id}', 
        tabs = { #{@tabs.keys.join(',')} }, 
        actions = { #{@tabs.values.join(',')} }
      }; 
      Aurita.register_tab_group(params); 
JS
    end

  end

end
end

