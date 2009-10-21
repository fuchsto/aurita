

module Aurita

  class Controller_Response

    attr_accessor :string, :script

    # Parameter result is value returned by controller method. 
    # Parameter response is the controller instance's @response object. 
    #
    def self.unify(result, response)
      response[:html]    = result.string if result.respond_to?(:string) 
      response[:script] << result.script if result.respond_to?(:script)
      return response
    end

  end

end

