
require('../spec_env')

Aurita::Main.import_model :content
Aurita::Main.import_model :strategies, :category_based_content_access

describe Aurita::Main::Category_Based_Content_Access do

  it "is a strategy controlling access to a content instance" do
    content    = Content.create(:user_group_id => 1)
    strategy   = Category_Based_Content_Access.new(content)
    user       = User_Group.get(1001)
    public_cat = Category.create(:category_name    => 'Public', 
                                 :public_readable  => true, 
                                 :public_writeable => true)

    strategy.permits_read_access_for(user).should == false
    strategy.permits_write_access_for(user).should == false
    
    content.add_category(public_cat)

    strategy.permits_read_access_for(user).should == true
    strategy.permits_write_access_for(user).should == true
    

  end

end
