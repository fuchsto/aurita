
require('aurita')
Aurita.import_module :gui, :module
Aurita.import_module :gui, :format_helpers
Aurita.import_module :gui, :i18n_helpers
Aurita.import_module :gui, :link_helpers
Aurita.import_module :gui, :page
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

    # /aurita/images/themes/custom/icons/

    def icon_tag(icon_name, css_class=nil)
      return HTML.img(:src => "/aurita/images/icons/#{icon_name}.gif", :class => css_class).string 

      theme   = Aurita.user.profile.theme
      theme   = 'default'
      return HTML.img(:src => "/aurita/images/icons/#{icon_name}.gif", :class => css_class).string if theme == 'default'
      return HTML.img(:src => "/aurita/images/themes/#{theme}/icons/#{icon_name}.gif", :class => css_class).string 
    end

  end # module

end # module
end # module

