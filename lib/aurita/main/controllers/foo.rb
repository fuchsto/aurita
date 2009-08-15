
require('aurita')

module Aurita
module Main

  class Foo_Controller < App_Controller

    def run
      redirect_to(:action => :target, :param => :value)
    end

    def target
      puts 'TARGET CALLED'
    end

  end

end
end

