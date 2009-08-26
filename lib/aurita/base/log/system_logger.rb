
require('aurita/config.rb')
require('logger')

module Aurita
module Log

  class System_Logger 
    
    def log(message=nil, &block)
      return if @disabled 
      message = yield if block_given?
      @logger.info { format_message(message) } 
    end

    private
    def format_message(message)
      "[ aurita ] #{ message}"
    end

    public
    def disable
      @disabled = true
    end
    def enable
      @disabled = false
    end
    def disabled?
      (@disabled == true)
    end
  

    public
    def debug(mesg=nil, &block)
      @logger.debug(mesg, &block)
    end
    def info(mesg=nil, &block)
      @logger.debug(mesg, &block)
    end
    def warn(mesg=nil, &block)
      @logger.debug(mesg, &block)
    end
    def error(mesg=nil, &block)
      @logger.debug(mesg, &block)
    end
    def fatal(mesg=nil, &block)
      @logger.debug(mesg, &block)
    end
    
    public
    def initialize(name)
      @logger = ::Logger.new(Aurita::Configuration.sys_log_path)
      @logger.level = ::Logger::DEBUG
      if Aurita::Configuration.sys_log_path then
        @name = name.to_s
        @disabled = false
      else
        @disabled = true
      end
    end
    
  end
end
end 

module Aurita
  
  @@system_logger = Aurita::Log::System_Logger.new('Aurita')

  def self.system_logger
    @@system_logger 
  end

  def self.enable_system_logger
    @@system_logger.enable
  end
  def self.disable_system_logger
    @@system_logger.disable
  end

  def self.log(message=nil, &block)
    return if @@system_logger.disabled? 
    return @@system_logger unless message

    project_name = Aurita.project.project_name.to_s if Aurita.project_loaded?
    project_name ||= 'core'
    message ||= yield
    @@system_logger.log { "[#{project_name}] " << message } 
  end

end

