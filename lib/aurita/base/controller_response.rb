

module Aurita

  class Controller_Response

    # Parameter result is value returned by controller method. 
    # Parameter response is the controller instance's @response object. 
    #
    def self.unify(result, response)
      response[:html] = result.string if result.respond_to?(:string) 
      if !response[:script] || response[:script].gsub(/\s/,'').length == 0 then
        response[:script] = result.script if result.respond_to?(:script)
      end
      return response
    end

  end

end

