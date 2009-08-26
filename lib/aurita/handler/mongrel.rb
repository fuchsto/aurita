
require 'mongrel'
require 'stringio'
require 'rack'
require 'rack/content_length'
require 'rack/chunked'
require 'aurita'

Aurita.import :rack_dispatcher
 
module Aurita
module Handler

  class Aurita_Application

    @@dispatcher = Aurita::Rack_Dispatcher.new()

    # Rack dispatch routine. 
    # Expects request env params, returns 
    # [ status, response header, response body ] 
    # of Aurita::Rack_Dispatcher instance. 
    def call(env)
      request    = Rack::Request.new(env)
      @@dispatcher.dispatch(request)

      [ @@dispatcher.status, @@dispatcher.response_header, @@dispatcher.response_body ]
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

    def initialize()
      @app = Rack::Chunked.new(Rack::ContentLength.new(Aurita::Handler::Aurita_Application.new))
    end
    
    def process(request, response)
      env = {}.replace(request.params)
      env.delete "HTTP_CONTENT_TYPE"
      env.delete "HTTP_CONTENT_LENGTH"

      env["SCRIPT_NAME"] = "" if env["SCRIPT_NAME"] == "/"

      rack_input = request.body || StringIO.new('')
      rack_input.set_encoding(Encoding::BINARY) if rack_input.respond_to?(:set_encoding)

      env.update({ "rack.version"      => [1,0],
                   "rack.input"        => rack_input,
                   "rack.errors"       => $stderr,
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
        response.send_header

        body.each { |part|
          response.write part
          response.socket.flush
        }
      ensure
        body.close if body.respond_to? :close
      end
    end

  end # class Aurita::Handler::Mongrel

end
end

