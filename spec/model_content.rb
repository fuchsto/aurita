
require 'aurita'
require('rubygems')

Aurita.load_project :default
Aurita::Main.import_model :content

include Aurita::Main

Content.extend Lore::Mockable

def mock_content(params={})
  mock_params = { 
    :content_id => 2342, 
    :user_group_id => 1, 
    :tags => [ :foo, :bar, :wombat ],
    :hits => 0, 
    :locked => 'f', 
    :deleted => 'f', 
    :concrete_model => '' 
  }.update(params)
  Content.mock(mock_params)
end

describe Aurita::Main::Content, "Content model" do
  before do
  end

  it("filters broken input for attribute 'tags'") do 
    c = mock_content(:tags => 'foo, bar wombat, bar')
    c.tags.should == 'foo bar wombat'
    c.tags.should == mock_content(:tags => [ :foo, :bar, :wombat, 'Bar']).tags
  end

  it("accepts new tags on method add_tags, ignoring dups") do
    c = mock_content(:tags => 'foo, bar wombat, bar')
    c.add_tags(:duck, :Wombat)
    c.tags.should == 'foo bar wombat duck'
  end


end
