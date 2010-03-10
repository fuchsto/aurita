
module Aurita
module Main

  class Abstract_Access_Strategy

    # Expects model instance to manage access control for. 
    def initialize(content)
      @instance = content
    end

    # Wheter given user has read access on the model instance 
    # protected by this access strategy. 
    def permits_read_acccess_for(user)
    end

    # Wheter given user has write access on the model instance 
    # protected by this access strategy. 
    def permits_write_access_for(user)
    end

    # Hook to be called from within Access_Strategy.use_access_strategy. 
    # Parameters in 'params' are passed to the concrete access strategy. 
    #
    #   Model_Klass.use_access_strategy(Concrete_Content_Access, 
    #                                   :managed_by => Content_Category, 
    #                                   :mapping    => { :content_id => :category_id })
    #   
    def self.on_use(klass, params={})
    end

  end

end
end

