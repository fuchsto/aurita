
require('aurita')

module Aurita

  # Usage: Extend Aurita::Model (esp. Aurita::Main::Content) with 
  # this helper module. 
  #
  # Example: 
  #
  #   class Content < Aurita::Model
  #     extend Access_Strategy
  #
  #     # Calls 
  #     #    Category_Based_Access_Control.on_use(Content)
  #     # 
  #     use_access_strategy Category_Based_Access_Control, :param => 'value'
  #
  #     ...
  #
  #   end
  #
  module Access_Strategy_Class_Methods
    @access_strategy_klass = nil
    @access_strategy_params = nil

    # Enable a concrete access strategy for this model klass. 
    # Given params are passed to the concrete access control strategy. 
    # See Aurita::Main::Abstract_Content_Access for details. 
    # 
    def use_access_strategy(klass, params={})
      klass.on_use(self, params)
      @access_strategy_params = params
      @access_strategy_klass  = klass
    end

    # Returns currently used access strategy klass 
    # previously set using .use_access_strategy. 
    def access_strategy
      @access_strategy_klass
    end

  end

  # Instance methods for Access_Strategy module. 
  # Automatically included when extending a klass with 
  # Access_Strategy. 
  module Access_Strategy

    # Hook called when extending a klass with this 
    # module. Automatically includes Access_Strategy_Instance_Methods 
    # into the klass extended. 
    #
    def self.included(extended_klass)
      extended_klass.extend(Access_Strategy_Class_Methods)
    end

    def access_strategy
      @access_strategy ||= self.class.access_strategy.new(self)
      @access_strategy
    end
  end

end
