
require('aurita')
require('lore/model')
require('lore/cache/mmap_entity_cache')
require('lore/cache/memcache_entity_cache')
require('lore/cache/memory_entity_cache')
Aurita.import_module :tagging

module Aurita

  # For general usage of models, see API documentation on Lore::Model. 
  #
  # 
  #
  class Model < Lore::Model
    extend Lore::Query_Shortcuts

  # use_entity_cache Lore::Cache::Memcache_Entity_Cache
  # use_entity_cache Lore::Cache::Memory_Entity_Cache
  # use_entity_cache Lore::Cache::Mmap_Entity_Cache

    # Return name of plugin this model is defined in as string. 
    # Example: 
    # 
    #   Wiki::Article.plugin_name  --> 'Wiki'
    #
    #   Aurita::Main::Content.plugin_name --> 'main'
    #
    def self.plugin_name
      plugin = self.to_s.split('::')[2..-2].join('/').downcase
      plugin = 'main' if plugin == ''
      plugin
    end

    # Helper for translation in model methods. 
    # Example: 
    #
    # class Some_Model < Aurita::Model
    #   def print
    #     tl(:some_language_code)
    #   end
    #   ...
    # end
    #
    def self.tl(language_symbol)
      Lang.get(plugin_name, language_symbol.to_s)
    end
    # See Aurita::Model.tl
    def tl(language_symbol)
      self.class.tl(language_symbol)
    end

    @@logger = Aurita::Log::Class_Logger.new(self.to_s)

    # Returns primary key values for this model 
    # instance as URL key, like 
    #  
    #  my_model_pkey_1=100&my_model_pkey_2=200
    #
    def url_key
      params = []
      key.each_pair { |attrib, value|
        params << "#{attrib.to_s}=#{value}"
      }
      return params.join('&')
    end

    # Return the REST resource path of this model entity. 
    # Example: 
    #  
    #   article = Wiki::Article.load(:article_id => 123)
    #   article.resource_path
    #   --> 'Wiki::Article/123'
    #
    def resource_path(action=nil)
      resource_path = model_name + '/' << key.values.join('_') 
      resource_path << '/' << action.to_s if action
      resource_path
    end

    # Return model name without leading namespaces. 
    # Example: 
    #
    #   Aurita::Plugins::Wiki::Article.model_name  --> 'Wiki::Article'
    #   Aurita::Main::Content.model_name           --> 'Content'
    #
    def self.model_name
      self.to_s.gsub('Aurita::Main::','').gsub('Aurita::Plugins::','')
    end
    # See Aurita::Model.model_name
    def model_name
      self.class.model_name
    end

    # Resolve name of controller for this model. 
    # Example: 
    #
    #    Aurita::Plugins::Wiki::Article.controller_name
    #    --> 
    #    'Wiki::Article_Controller'
    #
    def self.controller_name
      model_name + '_Controller'
    end
    # See Model.controller_name
    def controller_name
      self.class.controller_name
    end

    def self.log(message)
      @@logger.log(message)
    end

    def log(message)
      self.class.log(message)
    end

  end # class
  
end # module
