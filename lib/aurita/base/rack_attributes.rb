
require('stringio')
require('tempfile')
Aurita.import('base/attributes')

module Aurita

  # Proxy class for accessing CGI request parameters. 
  # Most probably, you will not need to use this class directly as 
  # it is wrapped by helpers. (See Aurita::Main::Base_Controller#param)
  #
  class Rack_Attributes < Attributes
  
    # Initialize by passing a model klass that will use this 
    # Attribute instance, as well as CGI request object or 
    # key/value Hash. 
    #
    # Usage: 
    #
    #   params = Attributes.new(Model_Klass, cgi_instance)
    # or:    
    #   params = Attributes.new(Model_Klass, hash)
    #
    def initialize(request) 
    # {{{
      super(request.params)
    end # def }}}

  end # class

end # module
