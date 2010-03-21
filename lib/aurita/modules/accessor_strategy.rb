
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
  module Accessor_Strategy_Class_Methods
    @accessor_strategy_klass  = nil
    @accessor_strategy_params = nil

    # Enable a concrete access strategy for this model klass. 
    # Given params are passed to the concrete access control strategy. 
    # See Aurita::Main::Abstract_Content_Access for details. 
    # 
    def use_accessor_strategy(klass, params={})
      klass.on_use(self, params)
      @accessor_strategy_params = params
      @accessor_strategy_klass  = klass
    end

    # Returns currently used access strategy klass 
    # previously set using .use_access_strategy. 
    def accessor_strategy
      @accessor_strategy_klass
    end

  end

  # Instance methods for Accessor_Strategy module. 
  # Automatically included when extending a klass with 
  # Access_Strategy. 
  module Accessor_Strategy

    # Hook called when extending a klass with this 
    # module. Automatically includes Access_Strategy_Instance_Methods 
    # into the klass extended. 
    #
    def self.included(extended_klass)
      extended_klass.extend(Accessor_Strategy_Class_Methods)
    end

    def accessor_strategy
      @access_strategy ||= self.class.access_strategy.new(self)
      @access_strategy
    end
  end

end
