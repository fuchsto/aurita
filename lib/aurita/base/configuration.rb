
module Aurita

  class Configuration_Store < Hash

    def method_missing(meth, *args)
      if meth.to_s[-1] != '='[0] then
        value = fetch(meth, nil) 
        if value.is_a? Proc then
          value = value.call
        end
        return value
      end
      
      args = args.first 
      return store(meth.to_s[0..-2].to_sym, args)
    end

  end

  # Simple configuration helper. Class method calls 
  # are redirected to setting or getting values, 
  # depending on parameters. 
  #
  # Usage: 
  #
  #   Car_Configuration < Configuration
  #
  #     motor :v8
  #     speed 210
  #     convertible false
  #
  #     # Use blocks for dynamic variables or lazy calls: 
  #     lazy_var { 'will be executed on request' }  
  #
  #   end
  #
  #   puts Car_Configuration.speed
  #   --> 
  #   210
  #
  #
  class Simple_Configuration

    def self.config
      @config ||= Configuration_Store.new
      @config
    end

    def self.method_missing(meth, *args, &block)
      if block_given? then
        args = block
      end
      return config.__send__(meth, *args) if !block_given? && args.length == 0
      return config.__send__("#{meth}=".to_sym, *args)
    end

  end

  class Configuration < Simple_Configuration

    def self.base_path
      "#{Aurita::App_Configuration.projects_base_path}#{config.project_name}/"
    end
    
    def self.db_cache(caching_impl)
      Lore::Table_Accessor.use_entity_cache(caching_impl)
      config[:db_cache] = caching_impl
    end
  end

end

