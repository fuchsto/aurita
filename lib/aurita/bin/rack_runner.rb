#/usr/bin/env ruby

module URI
  module REGEXP
    module PATTERN
      class PARAM
      end
    end
  end
end

require 'rubygems'
require 'rack'
require 'fcgi'
require 'aurita'

Aurita.load_project ARGV[0].to_sym
Aurita.bootstrap
Aurita.import 'handler/dispatcher'

port   = ARGV[1]
port ||= 3000

Aurita::Configuration.run_log_path = false
Aurita::Configuration.sys_log_path = false
Lore.disable_logging

class Aurita_Application
  def call(env)

    dispatcher = Aurita::Dispatcher.new()
    request    = Rack::Request.new(env)
    dispatcher.dispatch(request)

    [ 200, dispatcher.response_header, dispatcher.response_body ]
  end
end

Rack::Handler::Mongrel.run Aurita_Application.new, :Port => port

