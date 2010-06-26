
require('aurita/controller')

module Aurita
module Main 

  # This controller serves as a remote widget factory. 
  # Example: 
  # 
  #   Aurita.load_widget('MyPlugin::Entity_Table', { id: 'table_widget', columns: 5 }, callback_fun); 
  # 
  # In case the widget loaded should be put into a DOM element; 
  #
  #   Aurita.load_widget('MyPlugin::Entity_Table', 
  #                      { id: 'table_widget', columns: 5 }, 
  #                      Aurita.load_widget_to('target_dom_id'); 
  # --> (on server)
  #   Widget_Service_Controller.get(:widget  => 'MyPlugin::Entity_Table', 
  #                                 :id      => 'table_widget', 
  #                                 :columns => 5)
  # 
  # --> (on server, in controller)
  #   puts MyPlugin::Entity_Table.new(:id => 'table_widget', :columns => 5).string
  # 
  # <-- (HTML response to client)
  #   <table id="table_widget" ... >...</table>
  # 
  # Note that the requested widget has to reside in a plugin's GUI namespace (Aurita::Plugins::The_Plugin::GUI) 
  # or Aurita's GUI namespace (Aurita::GUI). 
  #
  class Widget_Service_Controller < App_Controller
    
    def get
      use_decorator(:async)
      
      widget_parts = param(:widget).to_s.split('::')
      if widget_parts.length > 1 then 
      # plugin widget
        begin
          Aurita.import_plugin_module(widget_parts[0].downcase.to_sym, "gui/#{widget_parts[1].downcase}")
        rescue ::Exception => ignore_load_error
        end
        widget = Aurita::Plugins.const_get(widget_parts[0]).const_get('GUI').const_get(widget_parts[1])
      elsif widget_parts.length == 1 then 
      # main widget
        begin
          Aurita.import_module :gui, widget_parts[0].downcase
        rescue ::Exception => ignore_load_error
        end
        widget = Aurita::GUI.const_get(widget_parts[0])
      end
      
      raise ::Exception.new("Could not resolve widget #{param(:widget).inspect}") unless widget
      
      ctor_args = @params.clean
      decorated = ctor_args[:decorated]
      ctor_args.delete(:widget)
      ctor_args.delete(:decorated)
      begin
        instance  = widget.new(ctor_args)
      rescue ::Exception => excep
        puts excep.message
        excep.backtrace.each { |b|
          puts "#{b}\n"
        }
        return
      end

      exec_js(instance.js_initialize.gsub(/\s+/,' ')) if instance.respond_to?(:js_initialize)

      if decorated then
        puts instance.decorated_element.to_s
      else
        puts instance.to_s
      end
    end
    
  end

end
end

