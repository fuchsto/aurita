
module Aurita
		
	class User_Runtime_Error < ::Exception
    def self.initialize(tag)
      if tag.is_a? Symbol then
        @message = Lang[tag] 
      else
        @message = tag.to_s
      end
    end
	end

	class User_Privilege_Error < User_Runtime_Error

	end 

end # module
