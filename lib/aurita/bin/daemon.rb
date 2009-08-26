

# From http://mongrel.rubyforge.org/browser/trunk/examples/mongrel_simple_service.rb

require 'rubygems'
require 'aurita'

require 'mongrel'
require 'yaml'
require 'zlib'

project_name = ARGV[0]
port         = ARGV[1]
port       ||= 3000
port         = port.to_i

if !project_name then
  puts "Usage: "
  puts "  daemon <project_name> <port>"
  exit
end

Aurita.load_project project_name.to_sym
Aurita.bootstrap
Aurita.import :handler, :mongrel

class Daemon 

  attr_accessor :logger

  def initialize(options)
    @options = options
    @aurita  = Aurita::Handler::Mongrel.new

    @http_server = Mongrel::HttpServer.new(@options[:ip], @options[:port])

    # Configure Mongrel for Aurita project: 
    @http_server.register("/", @aurita)
    @http_server.register("/aurita", @aurita)
    @http_server.register("/aurita/inc",    Mongrel::DirHandler.new(@options[:server_root] + '/inc'))
    @http_server.register("/aurita/assets", Mongrel::DirHandler.new(@options[:server_root] + '/assets'))
    @http_server.register("/aurita/images", Mongrel::DirHandler.new(@options[:server_root] + '/images'))
    @http_server.register("/aurita/shared", Mongrel::DirHandler.new(@options[:server_root] + '/shared'))

    @logger = Logger.new(STDERR)
  end
  
  def run
    @logger.info { "MongrelDaemon: run entered" }
    begin
      @logger.info { "MongrelDaemon: http_server.run" }
      @http_server.run.join
    rescue StandardError, ::Exception => err
      @logger.error { "MongrelDaemon: #{err}" }
      @logger.error { err.backtrace.join("\n") }
    end
    @logger.info { "MongrelDaemon: run left" }
  end
  
end

OPTIONS = {
  :port            => port,
  :ip              => "0.0.0.0",
  :server_root     => Aurita.project.base_path + '/public/' 
}

web_server = Daemon.new(OPTIONS)
web_server.run

