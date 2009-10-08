
require('rio')

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
  #
  class Simple

    attr_reader :controller
    attr_accessor :dependencies

    def initialize(controller_class)
      @controller       = controller_class
      @dependencies     = []
      @ignored_params   = [:controller, :action, :mode, :_controller, :_request, :_session]
    end

    def depends_on(*models)
      @dependencies = models
    end

    def store(params={}, &block)
      cache_content = yield
      File.open(Aurita.project.base_path + 'cache/' + cache_name(params), "w") { |f|
        f.write(Marshal.dump(cache_content))
      }
    end

    def get(params={})
      cache_content = false
      cache_path = Aurita.project.base_path + 'cache/' + cache_name(params)
      return false unless File.exists?(cache_path)

      File.open(cache_path, "r") { |f|
        cache_content = Marshal.load(f) 
      }
      cache_content
    end

    def invalidate(*actions)
      controller = @controller.to_s.split('::')[2..-1].join('__')
      controller.gsub!('_Controller','')
      cache_path = "#{controller.downcase}__*"
      begin
        rio(Aurita.project.base_path + "cache/").files(cache_path) { |file|
          file.rm
        }
      rescue Exception => ignore
        # No cache file to delete
      end
      # important, as some perform operations in controllers 
      # involuntarily return result of this method on .invalidate()
      return nil 
    end

    private

    # Cache file names are formatted like this: 
    #
    #   controller_name__action__U--user_id__param-value_param-value
    #
    def cache_name(params={})
      param_parts = []
      params.each_pair { |k,v| 
        param_parts << "#{k}-#{v}" unless @ignored_params.include?(k.to_sym)
      }
      params_string = param_parts.join('_')
      
      if Aurita.user then
        params_string = "U--#{Aurita.user.user_group_id}__#{params_string}"
      end
      
      controller = @controller.to_s.split('::')[2..-1].join('__')
      controller.gsub!('_Controller','')

      return "#{controller.downcase}__#{params[:action]}__#{params_string}"
    end

  end

end
end
