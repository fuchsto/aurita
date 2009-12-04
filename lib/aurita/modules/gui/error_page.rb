
require('aurita-gui/widget')
require('aurita/modules/gui/i18n_helpers')

module Aurita
module GUI

  # Widget used to render server errors. 
  # Expects an exception to render. 
  #
  class Error_Page < Widget
  include I18N_Helpers

    def initialize(exception)
      @exception = exception
      super()
    end

    def element
      HTML.div.server_error { 
        HTML.h1.error { tl(:error_header) } + 
        HTML.b.error_message { @exception.message } + 
        @exception.backtrace.map { |l| HTML.div.error_backtrace { l } }
      } 
    end

  end

end
end
