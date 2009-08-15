
require 'aurita'
require('aurita/base/log/class_logger')

module Aurita

  class Base_Application # :nodoc:
    @logger = Aurita::Log::Class_Logger.new(self.to_s)
    def self.log(mesg=nil, &block)
      @logger.debug(mesg, &block)
    end
  end

end
