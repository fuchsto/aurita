
require('aurita')
require('erb')
Aurita.import_module :gui, :lang
Aurita.import_module :gui, :erb_helpers

module Aurita
module Main

  # Decorators are like regular templates that wrap around 
  # controller output. 
  #
  # Every controller output is passed to a decorator template as a 
  # variable named 'content'. 
  # Example: 
  #
  #   <html>
  #    <head>
  #     <title>Simple full page decorator template</title>
  #    </head>
  #    <body>
  #
  #      <!-- page content returned via response[:html] -->
  #      <%= content %>
  #
  #      <script language="Javascript" type="text/js">
  #      <!--
  #      // javascript code returned via response[:script]
  #        <%= init_script %>
  #      -->
  #      </script>
  #
  #    </body>
  #   </html>
  #
  # Decorator templates are loaded from 
  #
  #   Aurita_project/views/decorators/<decorator_name>.rhtml
  #
  # So if you want to implement a completely different site layout for a
  # specific controller or controller method, define your decorator template 
  # in the projects decorator path, for example: 
  #
  #   Aurita_project/views/decorators/single_column.rhtml
  #
  # And activate it in a controller method using 
  #
  #   Aurita::Base_Controller.use_decorator(:single_column)
  #
  # So, in the controller, write: 
  #
  #   def list_as_single_column
  #     use_decorator(:single_column)
  #     # return GUI Element or print something 
  #   end
  #
  # The following decorator modes are defined in Default_Decorator
  # and needed for Aurita: 
  #
  # - :default
  #   Used if no decorator mode is given or if set explicitly. 
  #   Wraps controller output with template aurita_project/views/decorators/default.rhtml
  #   
  # - :async
  #   Wrap controller output as response to asynchronous request. 
  #   An asynchronous response is a JSON string containing the following fields: 
  #   - html: Plain HTML to display
  #   - script: Javascript code to execute onload
  #   - error: Javascript code for error handling
  #
  # - :none
  #   Do not decorate controller output at all, just return it as given. 
  #
  # To decide which decorator to use 
  #
  # If you want to define your own decorator class, derive from 
  # Default_Decorator and initialize your dispatcher with your custom
  # decorator class, like: 
  #
  #  dispatcher = Dispatcher.new()
  #  dispatcher.decorator = Custom_Decorator
  #  dispatcher.dispatch(cgi_request_obj)
  #
  class Default_Decorator

    # Constructor expects model klass to decorate, the controllers response 
    # object, and request params (GET, POST etc). 
    #
    # Example (seen from within a controller): 
    #
    #   dec = Default_Decorator.new(Article, @response, @params)
    #   dec.print 
    #
    # You will never need to instantiate decorators yourself, however, as 
    # decorators are handled in Aurita::Dispatcher automatically. 
    #
    def initialize(model_klass, response, params)
      @params      = params

      @mode = params[:mode].to_s
      if @mode == '' || @mode == 'default' || @mode == 'async' || @mode == 'none' then
        @mode = response[:decorator] if response[:decorator]
      end
      @mode = :default if @mode == ''
      @mode = @mode.to_s

      @template = ''
      if @mode == 'async' then
        response[:html].pack!
        @content  = "{ html: \"#{response[:html]}\", script: \"#{response[:script]}\""
        @content << ", debug: \"#{response[:debug]}\" " if response[:debug]
        @content << ", error: \"#{response[:error]}\" " if response[:error]
        @content << '}'
      elsif @mode == 'dispatch' || @mode == 'none' then
        @content = response[:html]
      else
        @mode   = Aurita.project.default_theme if @mode.to_s == 'default'
        @mode ||= 'default'
        project_template = Aurita.project_path + 'views/decorators/' << @mode + '.rhtml'

        if File.exists? project_template then
          file = project_template
        else 
          file = Aurita::Main::Application.base_path + 'views/decorators/' << @mode + '.rhtml'
        end
        IO.foreach(file) { |line|
          @template << line
        }
        @erb = ERB.new(@template)
        @binding = binding_for(response[:html], response[:script], model_klass, params, Lang)

        @content = @erb.result(@binding)
      end

    end

    def plugin_call(hook, call_params=nil)
      Aurita::Plugin_Register.call(hook, @params[:_controller], call_params)
    end
    def plugin_get(hook, call_params=nil)
      Aurita::Plugin_Register.get(hook, @params[:_controller], call_params)
    end

  protected

    def binding_for(content, init_script, model_klass, params, lang, project=Aurita::Project_Configuration, gui=Aurita::GUI::ERB_Helpers)
      binding
    end

  public

    def string()
      @content
    end

    def print()
      puts @content
    end

  end # class

end # module
end # module

