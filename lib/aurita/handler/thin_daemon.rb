#!/usr/bin/env ruby

require 'rubygems'
require 'aurita'

require 'yaml'
require 'zlib'

# require 'mongrel'

Aurita.import :handler, :aurita_application

module Aurita

  # Simple Thin daemon.
  # Starts Aurita project at given port. 
  # All loggers are redirected to STDERR. 
  # Example usage: 
  #
  #   sudo aurita/bin/thin_daemon my_project --port 3001 --mode development --log daemon.log &
  #
  # This would launch a single thin daemon handling 
  # an aurita application for project 'my_project' on 
  # port 3001 and write all log messages to file 
  # 'daemon.log'. 
  #
  class Thin_Daemon 
    include Aurita::Handler

    attr_accessor :logger

    def initialize(options)
      @options = options
      @logger  = options[:logger]
    end

    private 

    def setup

      @aurita_std  = Aurita_Application.new(@options)
      @aurita_poll = Aurita_Poller_Application.new(@options)
      root = @options[:server_root]
      @logger.debug("Server root is #{root}")

      app = Rack::URLMap.new('/'              => @aurita_std, 
                             '/aurita'        => @aurita_std, 
                             '/aurita'        => @aurita_std, 
                             '/aurita/poll'   => @aurita_std, 
                             '/aurita/inc'    => Aurita_Theme_File_Application.new(root+'/inc'), 
                             '/aurita/css'    => Aurita_Theme_File_Application.new(root+'/css'), 
                             '/aurita/shared' => Aurita_File_Application.new(root+'/shared'), 
                             '/aurita/script' => Aurita_File_Application.new(root+'/script'), 
                             '/aurita/assets' => Aurita_File_Application.new(root+'/assets'), 
                             '/aurita/images' => Aurita_Theme_File_Application.new(root+'/images'))

      @http_server = Thin::Server.new(@options[:ip], @options[:port], app) 

    end

    public
    
    def run
      setup()

      @logger.info { "Thin_Daemon: run entered" }
      begin
        @logger.info("Thin_Daemon: http_server.run")
        @http_server.start
      rescue StandardError, ::Exception => err
        @logger.error { "Thin_Daemon: #{err}" }
        @logger.error { err.backtrace.join("\n") }
      end
      @logger.info { "Thin_Daemon: run left" }
    end
    
  end # class

end # module
