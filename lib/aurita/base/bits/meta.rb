
module Aurita

  module ClassInheritableAttributes
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def attr_inheritable(*args)
        @inheritable_attributes ||= []
        @inheritable_attributes += args
        args.each { |a| 
          class << self; attr_accessor a.to_sym end
        }
        @inheritable_attributes
      end
      def inherited(subklass)
        @inheritable_attributes.each { |inheritable_attrib|
          instance_var = "@#{inheritable_attrib}"
          subklass.instance_variable_set(instance_var, instance_variable_get(instance_var))
        }
      end
  end

end
