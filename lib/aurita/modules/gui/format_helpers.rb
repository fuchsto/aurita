
require('aurita')
Aurita.import_module :gui, :helpers
Aurita.import_module :gui, :datetime_helpers

module Aurita
module GUI

  module Format_Helpers
  include Datetime_Helpers

    def decimal(num)
      return sprintf("%.2f", num.to_f)
    end

  end

end
end

