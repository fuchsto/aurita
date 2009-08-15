
require('aurita')
Aurita.import_module :gui, :lang

module Aurita
module GUI

  module I18N_Helpers

    @plugin_name = self.to_s.split('::')[2..-2].join('/').downcase

    def tl(language_symbol)
      Lang.get(plugin_name, language_symbol.to_s)
    end

    def plugin_name
      name_parts = self.class.to_s.split('::')
      if name_parts[1] == 'Main' then 
        plugin = :main
      elsif name_parts[1] == 'Plugins' then
        plugin = name_parts[2].downcase.to_sym
      else
        plugin = :main
      end
      return plugin
    end

    def tl(language_symbol)
      plugin   = plugin_name() 
      begin 
        Lang.get(plugin, language_symbol.to_s)
      rescue ::Exception => e
        raise ::Exception.new("Failed to resolve language pack for #{plugin}.#{language_symbol} in #{self.class.to_s}: #{e.message}")
      end
    end

  end

end
end
