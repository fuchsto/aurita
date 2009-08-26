

# From http://mongrel.rubyforge.org/browser/trunk/examples/mongrel_simple_service.rb

require 'rubygems'
require 'aurita'

require 'mongrel'
require 'yaml'
require 'zlib'

require 'win32/service'

DEBUG_LOG_FILE = File.expand_path(File.dirname(__FILE__) + '/debug.log') 

class SimpleHandler < Mongrel::HttpHandler
    def process(request, response)
      response.start do |head,out|
        head["Content-Type"] = "text/html"
        results = "<html><body>Your request:<br /><pre>#{request.params.to_yaml}</pre><a href=\"/files\">View the files.</a></body></html>"
        if request.params["HTTP_ACCEPT_ENCODING"] == "gzip,deflate"
          head["Content-Encoding"] = "deflate"
          # send it back deflated
          out << Zlib::Deflate.deflate(results)
        else
          # no gzip supported, send it back normal
          out << results
        end
      end
    end
end

class MongrelDaemon < Win32::Daemon
  def initialize(options)
    @options = options
  end
  
  def service_init
    File.open(DEBUG_LOG_FILE,"a+") { |f| f.puts("#{Time.now} - service_init entered") }

    File.open(DEBUG_LOG_FILE,"a+") { |f| f.puts("Mongrel running on #{@options[:ip]}:#{@options[:port]} with docroot #{@options[:server_root]}") } 

    @simple = SimpleHandler.new
    @files  = Mongrel::DirHandler.new(@options[:server_root])
    @aurita = Aurita_Handler.new

    @http_server = Mongrel::HttpServer.new(@options[:ip], @options[:port])
    # Configure Mongrel for Aurita project: 
    @http_server.register("/", @aurita)
    @http_server.register("/aurita", @aurita)
    @http_server.register("/aurita/inc", @files)
    @http_server.register("/aurita/assets", @files)
    @http_server.register("/aurita/images", @files)
    @http_server.register("/aurita/shared", @files)

    File.open(DEBUG_LOG_FILE,"a+") { |f| f.puts("#{Time.now} - service_init left") }
  end
  
  def service_stop
    File.open(DEBUG_LOG_FILE,"a+"){ |f|
      f.puts "stop signal received: " + Time.now.to_s
      f.puts "sending stop to mongrel threads: " + Time.now.to_s
    }
    #@http_server.stop
  end

  def service_pause
    File.open(DEBUG_LOG_FILE,"a+"){ |f|
      f.puts "pause signal received: " + Time.now.to_s
    }
  end
  
  def service_resume
    File.open(DEBUG_LOG_FILE,"a+"){ |f|
      f.puts "continue/resume signal received: " + Time.now.to_s
    }
  end

  def service_main
    File.open(DEBUG_LOG_FILE,"a+") { |f| f.puts("#{Time.now} - service_main entered") }
    
    begin
      File.open(DEBUG_LOG_FILE,"a+") { |f| f.puts("#{Time.now} - http_server.run") }
      @http_server.run
    
      # Note: maybe not loop in 1 second intervals?
      while state == RUNNING
        sleep 1
      end
      
    rescue StandardError, Exception, interrupt  => err
      File.open(DEBUG_LOG_FILE,"a+"){ |f| f.puts("#{Time.now} - Error: #{err}") }
      File.open(DEBUG_LOG_FILE,"a+"){ |f| f.puts("BACKTRACE: " + err.backtrace.join("\n")) }
      
    end
    
    File.open(DEBUG_LOG_FILE,"a+") { |f| f.puts("#{Time.now} - service_main left") }
  end
  
end

project_name = ARGV[0]
port         = ARGV[1]
port       ||= 3000
port         = port.to_i

if !project_name then
  puts "Usage: "
  puts "  daemon_win32 <project_name> <port>"
  exit
end

Aurita.load_project project_name.to_sym

OPTIONS = {
  :port            => port,
  :ip              => "0.0.0.0",
  :server_root     => Aurita.project.base_path + '/public/' 
}

web_server = MongrelDaemon.new(OPTIONS)
web_server.mainloop

