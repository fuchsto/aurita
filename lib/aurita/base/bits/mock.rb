
module Aurita

  class Mock_Object
    def initialize(params={})
      @params = params
    end

    def respond_to?(meth)
      @params.keys.include?(meth)
    end

    def method_missing(meth, *args)
      @params[meth]
    end

  end

end
