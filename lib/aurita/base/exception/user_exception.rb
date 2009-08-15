
module Aurita
		
	class User_Runtime_Error < ::Exception
    def self.initialize(tag)
      begin
        @message = Lang[tag]
      rescue
        @message = tag.to_s
      end
    end
	end

	class User_Privilege_Error < User_Runtime_Error

	end 

end # module
