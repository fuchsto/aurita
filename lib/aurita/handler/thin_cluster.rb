
require 'rubygems'
require 'aurita'

require 'yaml'
require 'zlib'

Aurita.import :handler, :thin_daemon

module Aurita

  # Simple Thin daemon.
  # Starts Aurita project at given port. 
  # All loggers are redirected to STDERR. 
  # Example usage: 
  #
  #   sudo aurita/bin/thin_daemon my_project --port 3001 --mode development & 
  #
  # This would launch a single mongrel daemon handling 
  # an aurita application for project 'my_project' on 
  # port 3001 and write all log messages to file 
  # 'daemon.log'. 
  #
  # Note that this daemon is *not* suitable for 
  # production mode, it's intended to quickly fire up 
  # a project to test your changes in development 
  # without restarting any real webserver. 
  #
  class Thin_Cluster
    include Aurita::Handler

    attr_accessor :threads, :logger

    # Usage: 
    #
    #   c = Thin_Cluster.new(:project    => :my_project, 
    #                        :ports      => [ 3000, 3001 ], 
    #                        :ip         => 0.0.0.0, 
    #                        :logger     => Logger.new(STDERR, 
    #                        :no_session => false, 
    #                        :chunked    => true)
    #                        
    #
    #
    def initialize(options)
      @options      = options
      @threads      = []
      @logger       = ::Logger.new(STDERR)
      @http_servers = []
    end

    private 

    def setup

      @aurita_std  = Aurita_Application.new(@options)
      @aurita_poll = Aurita_Poller_Application.new(@options)
      root = @options[:server_root]

      app = Rack::URLMap.new('/'                      => @aurita_std, 
                             '/aurita'                => @aurita_std, 
                             '/aurita'                => @aurita_std, 
                             '/aurita/poll'           => @aurita_poll, 
                             '/aurita/inc'            => Aurita_File_Application.new(root+'/inc'), 
                             '/aurita/shared'         => Aurita_File_Application.new(root+'/shared'), 
                             '/aurita/assets'         => Aurita_File_Application.new(root+'/assets'), 
                             '/aurita/images'         => Aurita_File_Application.new(root+'/images'))

      ports = @options[:ports]
      @options.delete(:ports)
      @options[:logger] = @logger
      ports.each { |port|
        STDERR.puts "Added daemon for port #{port}"
        @http_servers << Thin::Server.new(@options[:ip], port, app) 
      }

    end

    public
    
    def run
      setup()
      @http_servers.each { |server|
        @threads << Thread.new(server) { 
          STDERR.puts "Starting daemon"
          server.start
        }
      }
      @threads.each { |thread| thread.join }
    end
    
  end # class

end # module
