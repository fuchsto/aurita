
require 'aurita'
require 'aurita/modules/gui/error_page'
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

  class Aurita_Rack_Application
    def call(env)
      begin
        return @app.call(env)
      rescue ::Exception => e
        return [ 200, { 'Content-type' => 'text/html' }, Aurita::GUI::Error_Page.new(e) ]
        @logger.log(e.message)
        e.backtrace.each { |l|
          @logger.log(l)
        }
      end
    end
  end


  # Rack application covering Aurita's dispatching 
  # procedure only. 
  # Useful when building your own Rack application 
  # based on Aurita. 
  # See Aurita::Handler::Aurita_Application for an 
  # example of how to use this class. 
  #
  class Aurita_Dispatch_Application

    attr_accessor :logger, :gc_after_calls, :dispatcher
    attr_reader :calls

    def initialize(logger=nil)
      @logger         = logger
      @logger       ||= ::Logger.new(STDERR) 
      @dispatcher     = Aurita::Dispatcher.new()
      @calls          = 0
      @gc_after_calls = 60
    end

    public

    # Rack dispatch routine. 
    # Expects request env params, returns 
    # [ status, response header, response body ] 
    # of Aurita::Rack_Dispatcher instance. 
    #
    def call(env)
      @calls += 1
      if (@gc_after_calls && @calls > @gc_after_calls) then
        @calls = 0
        GC.enable
        GC.start
        GC.disable
      end
      response = @dispatcher.dispatch(Rack::Request.new(Aurita::Routing.new.route(env)))
      response[1]['Accept-Charset'] = 'utf-8' 
      response[1]['type']           = 'text/html; charset=utf-8' 
      response[1]['Cache-Control']  = 'private'
      return response
    end

  end

  # Default Rack application for handling dynamic requests 
  # to Aurita involving Aurita::Dispatcher. 
  #
  # Uses several middlewares that are sensible in nearly every 
  # case, like ETag, Session (memcache or pool, preferring memcache), 
  # Reloader (in :test and :development mode), Chunked, and ConditionalGet. 
  # Deflater and Chunked can be enabled / disabled by setting options 
  # :compress and :chunked to true or false. 
  #
  class Aurita_Application < Aurita_Rack_Application
    def initialize(options={})
      @options     = options

      @logger      = options[:logger]
      @logger    ||= ::Logger.new(STDERR) 

      @app = Aurita_Dispatch_Application.new(@logger)
      @app = Rack::ETag.new(@app)
      @app = Rack::ConditionalGet.new(@app)
      @app = Rack::Deflater.new(@app) if @options[:compress]
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

      GC.disable if @gc_after_calls
    end

  end

  # Rack application wrapping Aurita_Dispatch_Application, 
  # optimized for short response bodies. Almost all middlewares 
  # are disabled, except for Session, ContentLength and, in :test 
  # and :development modes, Reloader. 
  #
  class Aurita_Poller_Application < Aurita_Rack_Application
    def initialize(options={})
      @options     = options

      @logger      = options[:logger]
      @logger    ||= ::Logger.new(STDERR) 

      @app = Aurita::Handler::Aurita_Dispatch_Application.new(@logger)
      @app.dispatcher.poller = true
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

      GC.disable if @gc_after_calls
    end

  end

  # Rack application for serving aurita's static resources 
  # (files, that is), like assets, css, javascript etc. 
  class Aurita_File_Application < Aurita_Rack_Application
    def initialize(root)
      @app = Rack::File.new(root)
      @app = Rack::Deflater.new(@app) 
      @app = Rack::ETag.new(@app)
      @app = Rack::ConditionalGet.new(@app)
      @app = Rack::ContentLength.new(@app)
      @app = Rack::Chunked.new(@app) 

      @far_future = 'Thu, 15 Apr 2015 20:00:00 GMT'
    end

    def call(env)
      response = @app.call(env)
      response[1]['Expires'] = @far_future
      response[1].delete('Last-Modified')
      return response
    end
  end

end
end

