
require 'mongrel'
require 'stringio'
require 'rack'
require 'rack/content_length'
require 'rack/chunked'
require 'rack/session/memcache'
require 'aurita'

Aurita.import 'handler/rack_dispatcher'
 
module Aurita
module Handler

  class Aurita_Application

    @@dispatcher = Aurita::Rack_Dispatcher.new()

    private

    # Rewrite from 
    #
    #   <host>/aurita/Foo/bar[/param1=value&param2=value]
    #
    # to
    #
    #   <host>/aurita/?controller=Foo&action=bar[&param_1=value&param_2=value]
    #
    def rewrite_url(request)
      uri = request['REQUEST_URI']
      if !uri.include?('?') then
        uri_p = uri.split('/')
        if uri_p.length >= 4 && uri_p[1] == 'aurita' then
          host       = uri_p[0]
          controller = uri_p[2]
          action     = uri_p[3]
          get_params = uri_p[4]
          query = "controller=#{controller}&action=#{action}&#{get_params}"
          path  = "/aurita/run?#{query}"
          uri   = "#{host}#{path}"
          request['REQUEST_URI']  = uri
          request['REQUEST_PATH'] = path
          request['QUERY_STRING'] = query
        end
      end
    end

    public

    # Rack dispatch routine. 
    # Expects request env params, returns 
    # [ status, response header, response body ] 
    # of Aurita::Rack_Dispatcher instance. 
    def call(env)
      # Apply rewrites *before* creating Rack::Request from it: 
      rewrite_url(env) 
      STDERR.puts 'REWRITE ================================================='
      env.each_pair { |k,v|
        STDERR.puts "REWRITE #{k} - #{v.inspect}"
      }
      request    = Rack::Request.new(env)
      STDERR.puts "PARAMS: #{request.params.inspect}"
      STDERR.write(request['rack.errors'].read) if request['rack.errors']
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

    def initialize
      app = Aurita::Handler::Aurita_Application.new
      begin
        app = Rack::Session::Memcache.new(app, 
                                          :domain => Aurita.project.domain, 
                                          :expire_after => 2592000)
      rescue ::Exception => no_memcache
        app = Rack::Session::Pool.new(app, 
                                      :domain => Aurita.project.domain, 
                                      :expire_after => 2592000)
      end
      @app = Rack::Chunked.new(Rack::ContentLength.new(app))
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

