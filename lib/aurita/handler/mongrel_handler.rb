
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

Aurita.import :handler, :aurita_application
 
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

  # Aurita handler for Mongrel, derived from Mongrel::HttpHandler. 
  # Using Rack as Middleware. 
  #
  # This handler is to be used in setup of a Mongrel server instance: 
  #
  #   http_server = Mongrel::HttpServer.new(<ip>, <port>)
  #   http_server.register('/aurita', Aurita::Handler::Mongrel.new)
  #
  class Mongrel_Handler < ::Mongrel::HttpHandler

    attr_reader :logger

    def initialize(opts={})
      @app     = Aurita::Handler::Aurita_Application.new(opts)
      @adapter = Mongrel_Adapter.new(@app)
    end
    
    def process(request, response)
      @adapter.process(request, response)
    end

  end # class Aurita::Handler::Mongrel

  class Mongrel_Static_Handler < ::Mongrel::HttpHandler

    attr_reader :logger

    def initialize(opts={})
      @app       = Aurita::Handler::Aurita_File_Application.new(opts)
      far_future = 'Thu, 15 Apr 2015 20:00:00 GMT'
      @adapter   = Mongrel_Adapter.new(@app, 'Expires' => far_future)
    end
    
    def process(request, response)
      @adapter.process(request, response)
    end
    
  end # class Aurita::Handler::Mongrel_Static

end
end

