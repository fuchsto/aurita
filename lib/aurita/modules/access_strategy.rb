
require('aurita')

module Aurita

  # Usage: Extend Aurita::Model (esp. Aurita::Main::Content) with 
  # this helper module. 
  # Set an access strategy using: 
  #
  #    use_access_strategy(My_Access_Strategy)
  #
  module Access_Strategy_Class_Methods
    @access_strategy_klass = nil

    def use_access_strategy(klass)
      @access_strategy_klass = klass
    end

    def access_strategy
      @access_strategy_klass
    end

  end

  module Access_Strategy

    def self.included(includer_klass)
      includer_klass.extend(Access_Strategy_Class_Methods)
    end

    def access_strategy
      @access_strategy ||= self.klass.access_strategy.new(self)
      @access_strategy
    end
  end

end
