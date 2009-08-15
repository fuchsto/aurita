
require('aurita/controller')

Aurita::Main.import_controller :app_main
Aurita::Main.import_controller :hierarchy


module Aurita
module Main

  class App_My_Base_Controller < App_Controller

    def left
      puts App_Main_Controller.system_box
      puts Hierarchy_Controller.hierarchies_string('MY_BASE')
    end

    def main
      render_view('article_list.rhtml', 
                  :articles => Article.all_with(Article.tags.has_element('news')).entities)

    end

  end # class
  
end # module
end # module

