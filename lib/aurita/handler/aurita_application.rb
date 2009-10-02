
require 'aurita'
require 'aurita/base/routing'
require 'stringio'
require 'rack'
require 'rack/content_length'
require 'rack/chunked'
require 'rack/deflater'
require 'rack/static'
require 'rack/session/memcache'
require 'rack/contrib'
Aurita.import 'handler/dispatcher'

module Aurita
module Handler

  # Rack application covering Aurita's dispatching 
  # procedure only. 
  # Useful when building your own Rack application 
  # based on Aurita. 
  # See Aurita::Handler::Aurita_Application for an 
  # example of how to use this class. 
  #
  class Aurita_Dispatch_Application

    attr_accessor :logger

    def initialize(logger=nil)
      @logger      = logger
      @logger    ||= ::Logger.new(STDERR) 
      @dispatcher  = Aurita::Dispatcher.new()
    end

    public

    # Rack dispatch routine. 
    # Expects request env params, returns 
    # [ status, response header, response body ] 
    # of Aurita::Rack_Dispatcher instance. 
    #
    def call(env)
      @dispatcher.dispatch(Rack::Request.new(Aurita::Routing.new.route(env)))
    end

  end

  # Default Rack application for handling dynamic requests 
  # to Aurita involving Aurita::Dispatcher. 
  #
  # Uses several middlewares that are sensible in nearly every 
  # case, like ETag, Session (memcache or pool, preferring memcache), 
  # Reloader (in :test and :development mode), Chunked, Deflater
  # and ConditionalGet. 
  #
  class Aurita_Application
    def initialize(options={})
      @options     = options

      @logger      = options[:logger]
      @logger    ||= ::Logger.new(STDERR) 

      @app = Aurita::Handler::Aurita_Dispatch_Application.new(@logger)
      @app = Rack::ETag.new(@app)
      @app = Rack::ConditionalGet.new(@app)
      @app = Rack::Deflater.new(@app) 
      @app = Rack::ContentLength.new(@app)

      unless options[:no_session] then
        begin
          @app = Rack::Session::Memcache.new(@app)
        rescue ::Exception => no_memcache
          @logger.info { "#{self.class.to_s}: Falling back to Session::Pool" }
          @app = Rack::Session::Pool.new(@app)
        end
      end
    
      @app = Rack::Reloader.new(@app, 3) if [ :test, :development ].include?(Aurita.runmode)
      @app = Rack::Chunked.new(@app) if options[:chunked]
    end

    def call(env)
      @app.call(env)
    end
  end

  # Rack application for serving aurita's static resources 
  # (files, that is), like assets, css, javascript etc. 
  class Aurita_File_Application
    def initialize(root)
      @app = Rack::File.new(root)
      @app = Rack::Deflater.new(@app) 
      @app = Rack::ETag.new(@app)
      @app = Rack::ConditionalGet.new(@app)
      @app = Rack::ContentLength.new(@app)
      @app = Rack::Chunked.new(@app) 

      far_future = 'Thu, 15 Apr 2015 20:00:00 GMT'
    end

    def call(env)
      @app.call(env)
    end
  end

end
end

