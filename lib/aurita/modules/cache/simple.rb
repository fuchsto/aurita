

module Aurita
module Cache

  # A simple, transparent cache for controller responses. 
  # Usage: 
  #
  #   cache = Cache::Simple.new(Article_Controller)
  #   cache.depends_on(Article)
  #
  #   cache.store(:action => :show, :article_id => 123) { response }
  #
  # Response object is now stored in cache and can be retreived via #get: 
  #
  #   cache.get(:action => :show, :article_id => 123)
  #   --> response
  # 
  # On *any* create/update/delete operation on one of the 
  # models the cache object depends on (here: Article), *all*
  # cache objects assigned to this controller will be invalidated 
  # (deleted, that is). 
  #
  #
  class Simple

    attr_reader :controller, :dependencies

    def initialize(controller_class)
      @controller   = controller_class
      @dependencies = []
    end

    def depends_on(*models)
      @dependencies = models
    end

    def store(params={}, &bock)
      cache_content = yield
      File.open(Aurita.project.base_path + 'cache/' + cache_name, "w") { |f|
        f.write(Marshal.dump(cache_content))
      }
    end

    def get(params={})
      STDERR.puts params.inspect
      return false
      cache_content = false
      cache_path = Aurita.project.base_path + 'cache/' + cache_name(params)
      return false unless File.exists?(cache_path)
      File.open(cache_path, "r") { |f|
        cache_content = Marshal.load(f) 
      }
      cache_content
    end

    def invalidate
      cache_path = Aurita.project.base_path + "cache/#{@accessor.model_name.downcase}*"
      return false unless File.exists?(cache_path)
      File.rm(cache_path)
    end

    private

    def cache_name(params={})
      params_parts = []
      params.each_pair { |k,v|
        params_string << "#{k}-#{v}"
      }
      params_string = params_part.join('_')
      "#{@controller.model_name.downcase}__#{param_string}"
    end

  end

end
end
