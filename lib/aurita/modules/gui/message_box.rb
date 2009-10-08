
require('aurita')
Aurita.import_module :gui, :i18n_helpers

module Aurita
module GUI

  class Message_Box < Widget
    include I18N_Helpers

    def initialize(params={})
      @message = tl(params[:message].to_sym)
      super()
    end

    def element
      HTML.div.message_box { @message }
    end
    
  end

end
end

