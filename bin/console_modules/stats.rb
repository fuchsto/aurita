
require('aurita')

Aurita::Main.import_model :user_action
Aurita.import_plugin_model :wiki, :media_asset_download

module Aurita
module Console

  class Stats
  include Aurita::Main

    def initialize(argv)
      @from  = Time.now.to_datetime << 1 # One month earlier
      @to    = Time.now.to_datetime
      print_row('From', @from.strftime("%Y-%m-%d"))
      print_row('To',   @to.strftime("%Y-%m-%d"))
      puts '------------------------------------------------------------'
    end

    def run
      users     = User_Action.num_users(@from, @to)
      downloads = Wiki::Media_Asset_Download.num_downloads(:average => :daily, :from => @from, :to => @to)
      requests  = User_Action.num_requests(:average => :daily, :from => @from, :to => @to)
      visits    = User_Action.num_visits(:average => :daily, :from => @from, :to => @to)

      print_row('Active users total', users)
      print_row('Downloads total', downloads)
      print_row('Average requests / day', requests)
      print_row('Average visits / day', visits)
    end

    private

    def print_row(desc, value)
      STDOUT << desc
      (60-desc.length-value.to_s.length).times { STDOUT << ' ' }
      STDOUT << value.to_s
      STDOUT << "\n"
    end

  end

end
end

