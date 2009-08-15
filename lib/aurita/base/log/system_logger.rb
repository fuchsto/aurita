
require('aurita/config.rb')
require('logger')

module Aurita
module Log

  class System_Logger 
    
    def log(message=nil, &block)
      return if @disabled || System_Logger.disabled?
      message = yield if block_given?
      @logger.info(format_message(message))
    end

    private
    def format_message(message)
      @name + ': ' << message
    end

    public
    def disable
      @disabled = true
    end
    def disabled?
      @disabled
    end
  
    public
    def self.disable
      @all_disabled = true
    end
    def self.disabled? 
      @all_disabled
    end
    def self.enable
      @all_disabled = false
    end

    public
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
    
    public
    def initialize(name)
      if Aurita::Configuration.sys_log_path then
        @name = name.to_s
        @logger = ::Logger.new(Aurita::Configuration.sys_log_path)
        @logger.level = ::Logger::DEBUG
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
  def self.log(message=nil, &block)
    return if Aurita::Log::System_Logger.disabled? 
    project_name = Aurita.project.project_name.to_s if Aurita.project_loaded?
    project_name ||= 'core'
    message ||= yield
    @@system_logger.log { "[#{project_name}] " << message } 
  end

end

