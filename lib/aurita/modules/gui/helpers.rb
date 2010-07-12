
require('aurita')
Aurita.import_module :gui, :module
Aurita.import_module :gui, :format_helpers
Aurita.import_module :gui, :i18n_helpers
Aurita.import_module :gui, :link_helpers
Aurita.import_module :gui, :page
Aurita.import_module :gui, :icon
Aurita.import_module :gui, :toolbar_button
Aurita.import_module :gui, :text_button
Aurita.import_module :gui, :text_button_group
Aurita.import_module :gui, :button
Aurita.import_module :gui, :async_form_decorator
Aurita.import_module :gui, :async_upload_form_decorator

module Aurita
module GUI 

  module Helpers
  include I18N_Helpers
  include Link_Helpers

    def render(*args)
      first = args[0]
      case first
        when String
          if args[0][0] == '/' then
            render_file(args.at(0))
          elsif(false) then
          end
        when Form
          render_form(first)
        when Hash 
        when Symbol
          render_view(first, args[1..-1])
        else
      end
    end

    def render_file(aurita_path)
      path = Aurita::Main::Application.base_path + aurita_path
      if File.exists? path then
        File.open(path) { |file|
          file.each { |line| 
            puts line
          }
        }
      end
    end

    def js(&block)
      if block_given? then
        Javascript.build(&block)
      else
        Javascript
      end
    end

    # Returns GUI::Icon instance with given icon
    #
    def icon_tag(icon_name)
      GUI::Icon.new(icon_name).string
    end
    # Alias for icon_tag
    def icon(icon_name)
      GUI::Icon.new(icon_name).string
    end

  end # module

end # module
end # module

