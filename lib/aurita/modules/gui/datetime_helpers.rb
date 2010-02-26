
require('aurita')
Aurita.import_module :gui, :i18n_helpers

module Aurita
module GUI

  module Datetime_Helpers
    include Aurita::GUI::I18N_Helpers

    # Render the given date/time/datetime string or object in format 
    # configured in language pack (:date_format, :time_format, 
    # :datetime_format)
    def datetime_string(dt, format) 
      format = tl(format) if format.is_a?(Symbol)
      return '' unless dt
      if dt.is_a?(Date) || dt.is_a?(Datetime) then
        dt.strftime()
      elsif dt.kind_of?(String) then
        Aurita::Datetime.new(dt).string(format)
      end
    end

    # Parse date or datetime string or object to date of local format
    # using tl_main(:datetime_format)
    # Example: 
    #
    #     gui.date(date_object)  # --> '24/12/2008'
    #
    def date(date_string)
      datetime_string(date_string, :date_format)
    end
    # Parse date or datetime string or object to time of local format, 
    # using tl_main(:time_format)
    # Example: 
    #
    #     gui.datetime(date_object)  # --> '24/12/2008 - 23:45:23' 
    #
    def time(date_string)
      datetime_string(date_string, :time_format)
    end
    # Parse date or datetime string or object to date and time of local 
    # format, using tl_main(:datetime_format)
    # Example: 
    #
    #     gui.datetime(date_object)  # --> '23:45:23' 
    #
    def datetime(date_string)
      datetime_string(date_string, :datetime_format)
    end

  end

end
end

