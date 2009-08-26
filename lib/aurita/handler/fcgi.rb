
# Fixes issue with ruby 1.9
module URI
  module REGEXP
    module PATTERN
      class PARAM
      end
    end
  end
end

require('fcgi')
require('rubygems')
require('aurita')

Aurita.import :rack_dispatcher

module Aurita
module Handler

  class FCGI

    @@dispatcher = Aurita::Rack_Dispatcher.new()

    def initialize()
    end

    # Expects FCGI instance to retreive request 
    # from and to output response. 
    #
    # To be wrapped in FCGI loop, like: 
    #
    #   handler = Aurita::Handler::FCGI.new
    #   FCGI.each_cgi do |cgi|
    #     handler.process(cgi)
    #   end
    #
    def process(cgi)
      begin
        @@dispatcher.dispatch(cgi)
      rescue ::Exception => exception
        cgi.out { "#{exception.message}<br />
                   #{exception.backtrace.join('<br />')}" }
      ensure
        @@dispatcher.finish_request
      end
    end

  end # class Aurita::Handler::FCGI

end

