
require 'rubygems'
require 'mongrel'
require 'stringio'
require 'rack'
require 'rack/content_length'
require 'rack/chunked'
require 'rack/deflater'
require 'rack/static'
require 'rack/session/memcache'
require 'rack/contrib'
require 'aurita'
require 'aurita/base/routing'

Aurita.import 'handler/dispatcher'
 
module Aurita
module Handler

  class Mongrel_Adapter

    def initialize(app, extra_headers={})
      @app           = app
      @extra_headers = extra_headers
    end

    def process(request, response)
    # {{{
      env = {}.replace(request.params)
      env.delete "HTTP_CONTENT_TYPE"
      env.delete "HTTP_CONTENT_LENGTH"

      env["SCRIPT_NAME"] = "" if env["SCRIPT_NAME"] == "/"

      rack_input = request.body || StringIO.new('')
      rack_input.set_encoding(Encoding::BINARY) if rack_input.respond_to?(:set_encoding)

      env.update({ "rack.version"      => [1,0],
                   "rack.input"        => rack_input,
                   "rack.errors"       => STDERR,
                   "rack.multithread"  => true,
                   "rack.multiprocess" => false, # ???
                   "rack.run_once"     => false,
                   "rack.url_scheme"   => "http",
                 })
      env["QUERY_STRING"] ||= ""
      env.delete "PATH_INFO" if env["PATH_INFO"] == ""

      status, headers, body = @app.call(env)

      begin
        # Mapping Rack response to Mongrel response

        response.status = status.to_i
        response.send_status(nil)

        headers.each { |k, vs|
          vs.split("\n").each { |v|
            response.header[k] = v
          }
        }
        @extra_headers.each { |k, vs|
          vs.split("\n").each { |v|
            response.header[k] = v
          }
        }

        response.send_header

        body.each { |part|
          response.write part
          response.socket.flush
        }
      ensure
        response.socket.flush
        body.close if body.respond_to? :close
      end
    end # }}}

  end

  class Aurita_Application

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

  # Aurita handler for Mongrel, derived from Mongrel::HttpHandler. 
  # Using Rack as Middleware. 
  #
  # This handler is to be used in setup of a Mongrel server instance: 
  #
  #   http_server = Mongrel::HttpServer.new(<ip>, <port>)
  #   http_server.register('/aurita', Aurita::Handler::Mongrel.new)
  #
  class Mongrel < ::Mongrel::HttpHandler

    attr_reader :logger

    def initialize(opts={})
      @logger   = opts[:logger] 
      @logger ||= ::Logger.new(STDERR)
      @app = Aurita::Handler::Aurita_Application.new()
      @app.logger = @logger
      @app = Rack::ETag.new(@app)
      @app = Rack::ConditionalGet.new(@app)
      @app = Rack::Deflater.new(@app) 
      @app = Rack::ContentLength.new(@app)

      unless opts[:no_session] then
        begin
          @app = Rack::Session::Memcache.new(@app)
        rescue ::Exception => no_memcache
          @logger.info { "#{self.class.to_s}: Falling back to Session::Pool" }
          @app = Rack::Session::Pool.new(@app)
        end
      end
    
      @app = Rack::Reloader.new(@app, 3) if [ :test, :development ].include?(Aurita.runmode)
      @app = Rack::Chunked.new(@app) if opts[:chunked]

      @adapter = Mongrel_Adapter.new(@app)
    end
    
    def process(request, response)
      @adapter.process(request, response)
    end

  end # class Aurita::Handler::Mongrel

  class Mongrel_Static < ::Mongrel::HttpHandler

    attr_reader :logger

    def initialize(opts={})
      @app = Rack::File.new(opts[:root])
      @app = Rack::Deflater.new(@app) 
      @app = Rack::ETag.new(@app)
      @app = Rack::ConditionalGet.new(@app)
      @app = Rack::ContentLength.new(@app)
      @app = Rack::Chunked.new(@app) 

      far_future = 'Thu, 15 Apr 2010 20:00:00 GMT'
      @adapter   = Mongrel_Adapter.new(@app, 'Expires' => far_future)
    end
    
    def process(request, response)
      @adapter.process(request, response)
    end
    
  end # class Aurita::Handler::Mongrel_Static

end
end

