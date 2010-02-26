
require('aurita/plugin')

module Aurita
module Plugins
module Wiki


  # Usage: 
  #
  #  Aurita::Main::plugin_get(Hook.right_column)
  #
  class Plugin < Aurita::Plugin::Manifest

    register_hook(:controller => Media_Asset_Folder_Controller, 
                  :method     => :create_user_folders, 
                  :hook       => Hook.main.after_register_user)
    register_hook(:controller => Article_Controller, 
                  :method     => :recent_changes_in_category, 
                  :hook       => Hook.main.workspace.recent_changes_in_category)
    register_hook(:controller => Media_Asset_Controller, 
                  :method     => :recent_changes_in_category, 
                  :hook       => Hook.main.workspace.recent_changes_in_category)
    register_hook(:controller => Article_Controller, 
                  :method     => :toolbar_buttons, 
                  :hook       => Hook.main.toolbar)
    register_hook(:controller => Article_Controller, 
                  :method     => :recently_viewed_box, 
                  :hook       => Hook.main.right)
    register_hook(:controller => Media_Asset_Folder_Controller, 
                  :method     => :tree_box, 
                  :hook       => Hook.main.left)
    register_hook(:controller => Article_Controller, 
                  :method     => :find, 
                  :hook       => Hook.main.find)
    register_hook(:controller => Article_Controller, 
                  :method     => :find_full, 
                  :hook       => Hook.main.find_full)
    register_hook(:controller => Media_Asset_Controller, 
                  :method     => :find, 
                  :hook       => Hook.main.find)
    register_hook(:controller => Media_Asset_Controller, 
                  :method     => :find_full, 
                  :hook       => Hook.main.find_full)
    register_hook(:controller => Article_Controller, 
                  :method     => :find_all, 
                  :hook       => Hook.main.find_all)
    register_hook(:controller => Media_Asset_Controller, 
                  :method     => :find_all, 
                  :hook       => Hook.main.find_all)
    register_hook(:controller => Article_Controller, 
                  :method     => :own_articles_box, 
                  :hook       => Hook.main.my_place.left)
    register_hook(:controller => Article_Controller, 
                  :method     => :decorate_hierarchy_entry, 
                  :hook       => Hook.main.hierarchy.entry_decorator)

    register_hook(:controller => Article_Controller, 
                  :method     => :list_category, 
                  :hook       => Hook.main.category.list)
    register_hook(:controller => Media_Asset_Controller, 
                  :method     => :list_category, 
                  :hook       => Hook.main.category.list)

    register_hook(:controller => Autocomplete_Controller, 
                  :method     => :find_articles, 
                  :hook       => Hook.main.autocomplete_search.all)
    register_hook(:controller => Autocomplete_Controller, 
                  :method     => :find_media, 
                  :hook       => Hook.main.autocomplete_search.all)
                  
    register_hook(:controller => Article_Controller, 
                  :method     => :invalidate_and_show, 
                  :hook       => Hook.project.custom_form.perform_add)
    register_hook(:controller => Article_Controller, 
                  :method     => :invalidate_and_show, 
                  :hook       => Hook.project.custom_form.perform_delete)
    register_hook(:controller => Article_Controller, 
                  :method     => :invalidate_and_show, 
                  :hook       => Hook.project.custom_form.perform_update)

    # Article rendering 
    
    register_hook(:controller => Text_Asset_Controller, 
                  :method     => :article_partial, 
                  :hook       => Hook.wiki.article.hierarchy.partial) { |params|
      params[:part].is_a?(Text_Asset)
    }
    register_hook(:controller => Media_Container_Controller, 
                  :method     => :article_partial, 
                  :hook       => Hook.wiki.article.hierarchy.partial) { |params|
      params[:part].is_a?(Media_Container)
    }


  end

end
end
end


