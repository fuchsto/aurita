
require('aurita/controller')

Aurita::Main.import_controller :app_main


module Aurita
module Main

  class App_News_Controller < App_Controller

    def left
       
      puts App_Main_Controller.system_box
 
      tag_index = Box.new(:type => :topic, :class => :topic)
      tag_index.body = App_Main_Controller.tag_cloud
      tag_index.header = tl(:frequent_tags)
      puts tag_index.string

      hierarchy_list = ''
      Hierarchy.all_with(Hierarchy.category == 'NEWS').each { |h|
        box = Box.new(:type => :hierarchy, :class => :topic, :id => 'hierarchy_' << h.hierarchy_id, :params => { :hierarchy_id => h.hierarchy_id } )
        box.header = h.header
        box.body = view_string('hierarchy.rhtml', 
                               :entries => Hierarchy_Entry_Controller.list(h.hierarchy_id)
                              )
        hierarchy_list << box.string
      }
      
      puts hierarchy_list

    end

    def main
      render_view('article_list.rhtml', 
                  :articles => Article.all_with(Article.tags.has_element('aktuelles')).entities)
    end

    def list_recently_commented
      
      media_assets = Media_Asset.select { |ma|
        ma.join(User_Group).on(Content_Comment.user_group_id == User_Group.user_group_id) { |cma|
        cma.join(Content_Comment).on(Asset.content_id == Content_Comment.content_id) { |uma|
            uma.where(true)
            uma.order_by(:time, :desc)
            uma.limit(30)
          }
        }
      }
      articles = Article.select { |ma|
        ma.join(User_Group).on(Content_Comment.user_group_id == User_Group.user_group_id) { |cma|
        cma.join(Content_Comment).on(Asset.content_id == Content_Comment.content_id) { |uma|
            uma.where(true)
            uma.order_by(:time, :desc)
            uma.limit(30)
          }
        }
      }

      render_view(:content_list_recently_commented, 
                  :media_assets => media_assets, 
                  :articles => articles)
    end

  end # class
  
end # module
end # module

