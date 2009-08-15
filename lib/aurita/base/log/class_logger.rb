
require('logger')

module Aurita
module Log

  class Class_Logger 
    
    @name = self.to_s

    @all_disabled = false
    
    def log(message=nil, level=:info, &block)
      return if @disabled || Class_Logger.disabled? 

      message = yield if block_given?
      begin
        project_name = Aurita.project.project_name.to_s if Aurita.project
      rescue ::Exception => e
        # ignore
      end
      project_name ||= 'core'
      message = "[#{project_name}] #{@name} : #{message}"
      
      if level==:info then
        @logger.info(message)  
      elsif level==:warn then
        @logger.warn(message)  
      elsif level==:error then
        @logger.error(message) 
      elsif level==:fatal then
        @logger.fatal(message) 
      else 
        @logger.debug(message)
      end
    end

    def disable
      @disabled = true
    end

    def self.disable
      @all_disabled = true
    end
    def self.disabled? 
      @all_disabled
    end
    def self.enable
      @all_disabled = false
    end

    def debug(mesg)
      @logger.debug(mesg)
    end
    def info(mesg)
      @logger.debug(mesg)
    end
    def warn(mesg)
      @logger.debug(mesg)
    end
    def error(mesg)
      @logger.debug(mesg)
    end
    def fatal(mesg)
      @logger.debug(mesg)
    end
    
    def initialize(name)
      if Aurita::Configuration.run_log_path then
        @name = name.to_s
        @logger = ::Logger.new(Aurita::Configuration.run_log_path)
        @logger.level = ::Logger::DEBUG
        @disabled = false
      else
        @disabled = true
      end
    end
    
  end
end
end
