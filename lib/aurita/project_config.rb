require 'rubygems'
require 'configatron'

module Aurita

  class Project_Config

    def self.config
      @config
    end

    def self.method_missing(meth, *args)
      p meth
      @config ||= configatron
      @config.__send__(meth, *args)
    end

  end

end

