
require('aurita')

Aurita.import_plugin_model :wiki, :text_asset
Aurita.import_module :tagging

module Aurita
module Console

  class Reindex
    
    def initialize(argv=[])
    end

    def run()
      reindex()
    end

  private

    def reindex()
      Aurita::Plugins::Wiki::Text_Asset.all.each { |ta|
        Aurita.log { 'index for ' << ta.text_asset_id + " ...\n" }
        ta[:display_text] = Aurita::Main::Tagging.link_text_tags(ta.text.to_s.dup)
        ta[:tags] = 'text_asset'
        ta.commit
      }
    end

  end

end
end

