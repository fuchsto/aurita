
require 'aurita'
require 'aurita-gui/html'
require('rubygems')

Aurita.load_project :default
Aurita.import_plugin_model :wiki, :media_asset

include Aurita::Plugins::Wiki

describe Aurita::Plugins::Wiki::Media_Asset do
  before do
  end

  it "should be derived from polymorphic model Aurita::Main::Content" do
    m = Media_Asset.find(1).entity
    m.is_a?(Aurita::Main::Content).should == true
    Media_Asset.is_polymorphic?.should == false
    Aurita::Main::Content.is_polymorphic?.should == true
  end

end
