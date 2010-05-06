
require('aurita/controller')
Aurita::Main.import_model :content_history

module Aurita
module Main

  class Content_History_Controller < App_Controller

    def list_body

      user_filtered_cat_ids = Category_Feed_Filter.for(Aurita.user)
      user_filtered_cat_ids = [0] unless user_filtered_cat_ids.first
      feed_cat_ids          = Aurita.user.readable_category_ids
      feed_cat_ids -= user_filtered_cat_ids
      updates = Content.select { |c|
        c.where(Content.accessible & (Content.content_id.in { 
          Content_Category.select(:content_id) { |cid|
            cid.where(Content_Category.category_id.in(feed_cat_ids))
          }
        }))
        c.limit(20)
        c.order_by(:changed, :desc)
      }.to_a
      
      updates.each { |u|
        STDERR.puts "------------------------------------------------------"
        STDERR.puts "FILTER: " + u.category_ids.inspect
      } 


      updates = updates.map { |c| c.concrete_instance }

      changes = HTML.div(:class => [:recent_changes, :topic_inline]) { 
        updates.map { |c|
          user = c.user_profile
          cats = c.categories
          if cats.length == 1 then
            cat = cats[0]
            in_cats = "#{tl(:in_category)} #{link_to(cat) { cat.category_name } }"
          elsif cats.length > 1 then
            in_cats = "#{tl(:in_categories)} "
            in_cats << cats.map { |cat|
              "#{link_to(cat) { cat.category_name } }"
            }.join(', ')
          end

          if user then
            Context_Menu_Element.new(:entity => c) { 
              HTML.div(:class => [:index_entry, :listing ]) { 
                HTML.div { link_to(c) { HTML.b { c.title } } } + 
                HTML.div { datetime(c.changed) } +
                HTML.div { "#{link_to(user) { user.label }} #{in_cats}" } 
              }
            }
          end
        }
      }

      viewmode_icon = link_to(:controller => 'App_Main', 
                              :action     => 'recent_changes_in_categories', 
                              :element    => 'recent_changes_page_content') { 
        HTML.img(:src => '/aurita/images/icons/category_view.png')
      }.gsub('"','\"')
      exec_js("$('recent_changes_viewmode_icon').innerHTML = \"#{viewmode_icon}\"")

      return changes
    end

    def list

      viewmode_icon = link_to(:controller => 'App_Main', 
                              :action     => 'recent_changes_in_categories', 
                              :element    => 'recent_changes_page_content') { 
        HTML.img(:src => '/aurita/images/icons/category_view.png')
      }
      return Page.new(:header   => tl(:recent_changes), 
                      :sortable => true, 
                   #  :tools    => HTML.span(:id => :recent_changes_viewmode_icon) { 
                   #                 viewmode_icon
                   #               }, 
                      :id       => :recent_changes_page) { list_body } 

    end

    def list_defunct
      updates = Content.select { |c|
        c.join(Content_History).using(:content_id) { |cu|
#          ch.join(User_Group).on(Content.user_group_id == User_Group.user_group_id) { |cu|
            cu.where(Content.accessible & (Content_History.type <=> 'CHANGED'))
            cu.limit(40)
            cu.order_by(:time, :desc)
#          }
        }
      }.map { |c| c.concrete_instance }

      viewmode_icon = link_to(:controller => 'App_Main', 
                              :action     => 'recent_changes_in_categories', 
                              :element    => 'recent_changes_page_content') { 
        HTML.img(:src => '/aurita/images/icons/category_view.png')
      }
      exec_js("$('recent_changes_viewmode_icon').innerHTML = #{viewmode_icon}")

      HTML.div.topic_inline { 
        updates.map { |c|
          user = c.user_profile
          cats = c.categories
          if cats.length == 1 then
            cat = cats[0]
            in_cats = "#{tl(:in_category)} #{link_to(cat) { cat.category_name } }"
          elsif cats.length > 1 then
            in_cats = "#{tl(:in_categories)} "
            in_cats << cats.map { |cat|
              "#{link_to(cat) { cat.category_name } }"
            }.join(', ')
          end

          if user then
            HTML.div(:class => [:index_entry]) { 
              HTML.div(:class => [ :user_icon, :tiny ], :style => 'margin-right: 10px;') {
                HTML.img(:src => "/aurita/assets/tiny/asset_#{user.picture_asset_id}.jpg") 
              } +
              HTML.b { link_to(c) { c.title } } + 
              HTML.div { "#{link_to(user) { user.user_group_name }} #{in_cats}" } +
              HTML.div { datetime(c.changed) }
            }
          end
        }
      }
    end

  end

end
end

