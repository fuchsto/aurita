
require('aurita/controller')
Aurita::Main.import_controller :app_general

module Aurita
module Main

  class App_My_Place_Controller < App_General_Controller

    def left
      calc = Box.new({ :id => :calculator, :class => :topic })
      calc.header = 'Rechner'
      calc.body = view_string(:calculator)

      puts plugin_get(Hook.public.my_place.top).map { |component| component.string } 
      puts plugin_get(Hook.my_place.left.top).map { |component| component.string } 
      puts plugin_get(Hook.public.my_place.left).map { |component| component.string } 
      puts plugin_get(Hook.my_place.left).map { |component| component.string } 
      puts plugin_get(Hook.my_place.left.hierarchies, :perspective => 'MY_PLACE').map { |h| h.string } 
      exec_js("Effect.Appear('app_left_column'); ")
    end

  end # class
  
end # module
end # module

