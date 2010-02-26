
require('aurita/controller')

Aurita::Main.import_model :hierarchy_entry
Aurita::Main.import_model :hierarchy
Aurita::Main.import_model :user_online
Aurita::Main.import_model :user_profile
Aurita::Main.import_model :user_online
Aurita::Main.import_controller :user_profile
Aurita::Main.import_controller :hierarchy_entry
Aurita::Main.import_controller :app_general
Aurita::Main.import_controller :app_main

module Aurita
module Default

  class App_Main_Controller < Aurita::Main::App_Main_Controller
    
    def tag_index
      view_string(:tag_index, :tags => Tag_Index.all.entities)
    end

  end # class
  
end # module
end # module

