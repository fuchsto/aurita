
require('yaml')

class Language_Pack

  def initialize(pack, params={})
    @lang   = params[:lang].to_sym
    @plugin = params[:plugin].to_sym
    @pack   = pack
  end

  def [](symbol)
    s = @pack[@plugin][@lang][symbol]
    return s if s
    s = @pack[:main][@lang][symbol] if symbol != :main
    return s if s
    return s.to_s
  end

end

class Lang

  @@language_packs = { :main => { :de => YAML::load(File::open(Aurita::Application.base_path+'main/lang/de.yaml')), 
                                  :en => YAML::load(File::open(Aurita::Application.base_path+'main/lang/en.yaml'))
                                } 
  }

  def self.add_plugin_language_pack(plugin_name)
    yaml_path = Aurita::Configuration.plugins_path + plugin_name + '/lang/'
    plugin_name = plugin_name.downcase.to_sym
    @@language_packs[plugin_name] = {}
    Dir.glob(yaml_path + '*.yaml').each { |f|
      lang = f.split('/').at(-1).gsub('.yaml','').to_sym
      pack = (YAML::load(File::open(f)))
      @@language_packs[plugin_name][lang] = pack unless @@language_packs[plugin_name][lang]
      @@language_packs[plugin_name][lang].update(pack) if @@language_packs[plugin_name][lang]
    }
  end

  def self.add_project_language_pack(plugin_name)
    yaml_path = Aurita.project.base_path + 'plugins/' << plugin_name + '/lang/'
    plugin_name = plugin_name.downcase.to_sym
    @@language_packs[plugin_name] = {}
    Dir.glob(yaml_path + '*.yaml').each { |f|
      lang = f.split('/').at(-1).gsub('.yaml','').to_sym
      pack = (YAML::load(File::open(f)))
      @@language_packs[plugin_name][lang] = pack unless @@language_packs[plugin_name][lang]
      @@language_packs[plugin_name][lang].update(pack) if @@language_packs[plugin_name][lang]
    }
  end

  def self.get(plugin, symbol)
    plugin = plugin.to_sym
    symbol = symbol.to_s
    lang = Aurita.session.language.to_sym
    if !@@language_packs[plugin][lang] then
      error  = 'Missing language pack: Plugin ' << plugin.inspect + ', language ' << lang.inspect + "\n"
      raise ::Exception.new(error) 
    end
    s = @@language_packs[plugin.to_sym][lang][symbol]
    return s if s
    s = @@language_packs[:main][lang][symbol]
    return s if s
    return plugin.to_s + '__' + symbol.to_s
  end

  def self.[](plugin_name)
    return Language_Pack.new(@@language_packs, 
                             :lang => Aurita.session.language, 
                             :plugin => plugin_name)
  end

end

