#!/usr/bin/env ruby

require 'rubygems'
require 'aurita'

require 'mongrel'
require 'yaml'
require 'zlib'

Aurita.import :handler, :mongrel_handler

# Simple Mongrel daemon. 
# Starts Aurita project at given port. 
# All loggers are redirected to STDERR. 
# Example usage: 
#
#   sudo aurita/bin/mongrel_daemon my_project --port 3001 --mode development & 
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
module Aurita
class Mongrel_Daemon 

  attr_accessor :logger

  def initialize(options)
    @options = options
  end

  private 

  def setup
    @aurita  = Aurita::Handler::Mongrel_Handler.new(:compress    => @options[:compress], 
                                                    :chunked     => @options[:chunked], 
                                                    :no_sessions => @options[:no_sessions], 
                                                    :logger      => @logger)
    root = @options[:server_root]

    @http_server = Mongrel::HttpServer.new(@options[:ip], @options[:port], 950, 0)

    # Configure Mongrel for Aurita project: 
    @http_server.register("/", @aurita)
    @http_server.register("/aurita", @aurita)
    @http_server.register("/aurita/inc",    Aurita::Handler::Mongrel_Static_Handler.new(:root => root + '/inc'))
    @http_server.register("/aurita/assets", Aurita::Handler::Mongrel_Static_Handler.new(:root => root + '/assets'))
    @http_server.register("/aurita/images", Aurita::Handler::Mongrel_Static_Handler.new(:root => root + '/images'))
    @http_server.register("/aurita/shared", Aurita::Handler::Mongrel_Static_Handler.new(:root => root + '/shared'))
  end

  public
  
  def run
    setup()

    @logger.info { "Mongrel_Daemon: run entered" }
    begin
      @logger.info("Mongrel_Daemon: http_server.run")
      @http_server.run
      @http_server.acceptor.join
    rescue StandardError, ::Exception => err
      STDERR.puts err.inspect
      @logger.error { "Mongrel_Daemon: #{err}" }
      @logger.error { err.backtrace.join("\n") }
    end
    @logger.info { "Mongrel_Daemon: run left" }
  end
  
end # class
end # module
