
require('aurita')
require('aurita-gui/widget')
require('aurita-gui/form')
Aurita.import_module :gui, :extras, :glassbox

module Aurita
module GUI

  class Swapping_Menu_Level < Aurita::GUI::Widget
    include Aurita::GUI::Link_Helpers

    attr_reader :entries, :level

    def initialize(entries, params={})
      @level   = params[:level].to_i
      @level   = 1 if @level < 1
      @entries = entries
      super()
    end

    def element
      HTML.ul(:id => "main_navigation_entries_col_#{@level}", :class => [ :navigation_entries, "column_#{@level}" ]) { 
        @entries.map { |e|
          load_content = "Aurita.swapping_menu.show_column({ parent_id: #{e.hierarchy_entry_id}, column: #{@level.to_i+1}});"
          if !e.has_children? then
            close_menu = "Aurita.swapping_menu.park();"
          else 
            close_menu = ''
          end
          if e.content_id then
            c = Content.get(e.content_id).concrete_instance
            HTML.li { link_to(c, :options => { :onclick => "#{load_content} #{close_menu}" } ) { e.label } } 
          elsif e.interface.to_s != '' then
            if e.interface[0..6] == 'http://' then
              HTML.li { HTML.a(:href => e.interface, :target => :_blank) { e.label } }
            else
              HTML.li { HTML.a(:href => e.interface) { e.label } }
            end
          else
            HTML.li { HTML.a(:onclick => "#{load_content} #{close_menu}" ) { e.label } } 
          end
        }
      }
    end

  end

  class Swapping_Menu < Aurita::GUI::Widget
    include Aurita::GUI::Link_Helpers

    # Structure of hierarchy: 
    #
    #   navi = Navigation.new([ hierarchy_1, hierarchy_2 ... ])
    #
    #
    def initialize(params={})
      @hierarchies = params[:hierarchies]
      @params      = params
      @track       = params[:track]
      @params.delete(:track)
      @params.delete(:hierarchies)
      super()
    end

    def js_initialize
<<CODE
  new Aurita.GUI.Tooltip('btn_home',    { position: 'absolute', tooltip: 'tooltip_home' });
  new Aurita.GUI.Tooltip('btn_contact', { position: 'absolute', tooltip: 'tooltip_contact' });
  new Aurita.GUI.Tooltip('btn_videos',  { position: 'absolute', tooltip: 'tooltip_videos' });
  new Aurita.GUI.Tooltip('btn_mailbox', { position: 'absolute', tooltip: 'tooltip_mailbox' });
CODE
    end

    def element

      buttons = @hierarchies.map { |h|
        action = ''
        if h.interface.to_s != '' then
          action = "Aurita.load({ action: '#{h.interface}' }); WFV.menu.park(); "
        else
          action = "Aurita.swapping_menu.swap(#{h.hierarchy_id});"
        end
        HTML.a(:onclick => action, 
               :class   => [ :navigation, :button ]) { 
          h.header
        } 
      }

      HTML.div.black(:id => :navigation) { 
        HTML.div(:id    => :main_navigation_badge, 
                 :class => [ :main_navigation_badge, :white ]) { 
          HTML.div.main_navigation_badge_body { 
            HTML.img.logo(:id => :logo_img, :src => '/aurita/images/logo.png') + 
            HTML.div.main_navigation_bar_wrap { 
              HTML.div.main_navigation_bar { 
                buttons + 
                HTML.div.main_navigation_widgets { 
                  HTML.div.search_box { 
                    HTML.form(:name     => 'global_search_form', 
                              :onsubmit => "Aurita.load({ action: 'App_Main/find/key='+$('global_search').value }); return false;") { 
                      HTML.input.global_search(:name => :key, :id => :global_search) +
                      HTML.img.icon(:src     => '/aurita/images/search.gif', 
                                    :onclick => "Aurita.load({ action: 'App_Main/find/key='+$('global_search').value });") 
                    } 
                  } + 
                  HTML.div.icons { 
                    link_to(:controller => 'App_Main', :action => :frontpage) { 
                      HTML.div.tooltip(:style => 'display: none;', 
                                       :id    => :tooltip_home) { 'Startseite' } + 
                      HTML.img.icon(:id  => :btn_home, 
                                    :src => '/aurita/images/home.gif') 
                    } +
                    link_to(:controller => 'Wiki::Article', :action => :show, :id => 3715) { 
                      HTML.div.tooltip(:style => 'display: none;', 
                                       :id    => :tooltip_contact) { 'Kontakt' } + 
                      HTML.img.icon(:id  => :btn_contact, 
                                    :src => '/aurita/images/contact.gif')
                    } +
                    HTML.a(:href   => 'http://85.10.207.151/engines/redition/project/files/weiterleitung_postfach.html', 
                           :target => '_blank') { 
                      HTML.div.tooltip(:style => 'display: none;', 
                                       :id    => :tooltip_mailbox) { 'E-Postfach' } + 
                      HTML.img.icon(:id  => :btn_mailbox, 
                                    :src => '/aurita/images/mailbox.gif')
                    } +
                    HTML.a(:href => '#', :onclick => "WFV.popup('http://www.wfv.info//wfv_videoportal/wfv_videoportal.html',700,700);") { 
                      HTML.div.tooltip(:style => 'display: none;', 
                                       :id    => :tooltip_videos) { 'Videos' } + 
                      HTML.img.icon(:id  => :btn_videos, 
                                    :src => '/aurita/images/video.gif')
                    }
                  } 
                }
              }
            } 
          } +
          HTML.div.main_navigation_badge_footer { } 
        } + 
        HTML.div(:id => :main_navigation, :class => :black) { 
          Glassbox.new(:id => :box_main_navigation) { 
            HTML.div(:id => :main_navigation_entries) { 
            } + 
            HTML.div(:id => :main_navigation_footer, :style => 'display: none;') { '' } 
          }
        }
      }
    end

  end

end
end

