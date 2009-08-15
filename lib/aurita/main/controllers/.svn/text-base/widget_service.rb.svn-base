
require('aurita/controller')

module Aurita
module Main 

  # This controller serves as a remote widget factory. 
  # Example: 
  # 
  #   Aurita.get_widget('MyPlugin::Entity_Table', { id: 'table_widget', columns: 5 }); 
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
      begin
        widget_parts = param(:widget).to_s.split('::')
        if widget_parts.length > 1 then       # plugin widget
          widget = Aurita::Plugins.const_get(widget_parts[0]).const_get('GUI').const_get(widget_parts[1])
        elsif widget_parts.length == 1 then   # main widget
          widget = Aurita::GUI.const_get(widget_parts[0])
        end
        ctor_args = @params.dup
        ctor_args.delete(:request)
        ctor_args.delete(:widget)
        ctor_args.delete(:controller)
        ctor_args.delete(:action)
        ctor_args.delete(:mode)
        instance = widget.new(ctor_args)
        result   = instance.string
      rescue ::Exception => e
        exec_error_js("alert('e.message');")
      end
      puts result
    end
    
  end

end
end

