#!/usr/bin/env ruby

require 'rubygems'
require 'aurita'

require 'yaml'
require 'zlib'

# require 'mongrel'

Aurita.import :handler, :aurita_application
Aurita.import :handler, :thin_daemon

module Aurita

  # Simple Thin daemon, configured for *unguared*, short and frequent requests.
  # Unguarded means there is no permission control and session management at all 
  # for the sake of low latency. 
  # Do not handle requests using the gatling daemon unless its responses are 
  # considered public! 
  #
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
  class Thin_Gatling_Daemon < Thin_Daemon 
    include Aurita::Handler

    private 

    def setup

      @aurita_poll = Aurita_Poller_Application.new(@options)
      root = @options[:server_root]

      app = Rack::URLMap.new('/'              => @aurita_poll, 
                             '/aurita'        => @aurita_poll, 
                             '/aurita/poll'   => @aurita_poll, 
                             '/aurita/inc'    => Aurita_Theme_File_Application.new(root+'/inc'), 
                             '/aurita/css'    => Aurita_Theme_File_Application.new(root+'/css'), 
                             '/aurita/shared' => Aurita_File_Application.new(root+'/shared'), 
                             '/aurita/script' => Aurita_File_Application.new(root+'/script'), 
                             '/aurita/assets' => Aurita_File_Application.new(root+'/assets'), 
                             '/aurita/images' => Aurita_Theme_File_Application.new(root+'/images'))

      @http_server = Thin::Server.new(@options[:ip], @options[:port], app) 

    end
    
  end # class

end # module
