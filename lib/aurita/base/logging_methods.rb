
Aurita.import(:base, :log, :class_logger)

module Aurita

  module Logging_Methods

    @logger = Aurita::Log::Class_Logger.new(self)

    # Usage: 
    #
    #   log('Log message')
    #
    # or 
    #
    #   log.debug('Log message')
    #
    # same as
    # 
    #   log('Log message', :debug)
    #
    # preferred usage is using a block, since the block 
    # will not be evaluated if logging is disabled or the 
    # log level is ignored: 
    #
    #   log.debug { "Some complex method result: #{compute_universe()}" }
    #
    #
    def log(message=nil, level=nil, &block)
      @logger ||= Aurita::Log::Class_Logger.new(self)
      return @logger unless (message || block_given?)
      @logger.log(message, level, &block)
    end

  end

end
