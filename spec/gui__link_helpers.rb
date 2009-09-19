
require 'aurita'
require 'aurita-gui/html'
require('rubygems')

Aurita.load_project :default
Aurita.bootstrap
include Aurita::Plugins

require('aurita/modules/gui/link_helpers')

include Aurita::GUI
include Aurita::GUI::Link_Helpers

describe Aurita::GUI::Link_Helpers, "URL rendering" do
  before do
    $mock_article = Aurita::Plugins::Wiki::Article.mock(:content_id => 4321, 
                                                        :article_id => 1234, 
                                                        :pass       => 'foo', 
                                                        :login      => 'mock', 
                                                        :tags       => [ :foo, :bar, :batz ], 
                                                        :user_group_id => 100, 
                                                        :title      => 'Mock article')
  end

  it "should provide a shortcut for actions" do
    url = "Aurita.load({ action: 'Some_Controller/add/' }); "
    link_to(:add, :controller => 'Some_Controller').should == url
  end

  it "should provide a shortcut for labels" do
    url = "<a onclick=\"Aurita.load({ action: 'Some_Controller/show/' }); return false; \" href=\"#Some_Controller/show/\">show some controller</a>"
    link_to('show some controller', :controller => 'Some_Controller').should == url
  end

  it "does not modify plain urls" do
    url = 'http://somedomain.com/some/path/script.ext?param=value&param2=foo'
    url_for(url).should == url
  end

  it "returns resource paths for Aurita::Model instances" do
    resource_path = '/aurita/Wiki::Article/show/article_id=1234'
    url_for($mock_article).should == resource_path

    resource_path = '/aurita/Wiki::Article/add/'
    url_for(Wiki::Article, :action => :add).should == resource_path

    resource_path = '/aurita/Wiki::Article/show/article_id=1234&viewparams=plain'
    url_for($mock_article, :action => :show, :viewparams => :plain).should == resource_path
  end

  it "returns RESTful URLs on method rest_url_for" do
    resource_path = 'Wiki::Article/1234'
    rest_url_for($mock_article).should == resource_path

    resource_path = 'Wiki::Article/add'
    rest_url_for(Wiki::Article, :action => :add).should == resource_path

    resource_path = 'Wiki::Article/1234/show/viewparams=plain'
    rest_url_for($mock_article, :action => :show, :viewparams => :plain).should == resource_path
  end

  it "returns javascript: history.back(); on parameter :back" do
    s = 'javascript: history.back();'
    url_for(:back).should == s
  end

  it "returns full <a> tags as link to a resource on method link_to" do
    s = '<a onclick="Aurita.load({ action: \'Wiki::Article/show/article_id=1234\' }); return false; " href="#Wiki::Article/show/article_id=1234">Mock article</a>'
    link_to('Mock article', $mock_article).should == s
  end

  it "returns onclick=... tag attribute as link to a resource on method onclick_link_to" do
    s = 'Aurita.load({ action: \'Wiki::Article/show/article_id=1234\' }); '
    js_link_to(:entity => $mock_article).should == s
    s = 'Aurita.load({ action: \'Wiki::Article/show/article_id=1234\' , element: \'left_col\' }); '
    js_link_to(:entity => $mock_article, :element => :left_col).should == s
  end

end
