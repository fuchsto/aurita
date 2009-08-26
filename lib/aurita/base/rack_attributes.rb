
require('stringio')
require('tempfile')
require('rack/request')
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
    #   params = Attributes.new(Model_Klass, request)
    # or:    
    #   params = Attributes.new(Model_Klass, hash)
    #
    # A request object has to provide method #params, 
    # returning key/value hash of all request params 
    # (such as GET and POST)
    #
    def initialize(request) 
    # {{{
      super(request)
    end # def }}}

  end # class

end # module
