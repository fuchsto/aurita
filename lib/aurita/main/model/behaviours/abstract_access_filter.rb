
module Aurita

  module Abstract_Access_Filter_Instance_Behaviour

    def accessible
    end
    alias accessible? accessible
    alias is_accessible accessible
    alias is_accessible? accessible

  end
    
  module Abstract_Access_Filter_Behaviour

    def accessible
    end
    alias accessible? accessible
    alias is_accessible accessible
    alias is_accessible? accessible

    def self.extended(extended_klass)
      extended_klass.include(Abstract_Access_Filter_Instance_Behaviour)
    end

  end

end

