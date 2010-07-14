
require('aurita/base/bits/blank_object')

class Negate_Object < Blank_Object

  def initialize(object)
    @object = object
  end

  def method_missing(symbol, *args)
    !@object.send(symbol, *args)
  end
end

class Object
  def not
    Negate_Object.new(self)
  end
end


