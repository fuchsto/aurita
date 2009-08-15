
require('aurita/controller')

# Aurita::Main.import_controller :article
Aurita::Main.import_controller :hierarchy_entry

module Aurita
module Main

  class App_Media_Controller < App_Controller

    def left
      puts 'App_Media.left'
    end

    def main
      puts 'App_Media.main'
    end

  end # class
  
end # module
end # module

