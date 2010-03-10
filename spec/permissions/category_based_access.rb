
require('./spec_env')

Aurita::Main.import_model :content
Aurita::Main.import_model :content_category
Aurita::Main.import_model :strategies, :category_based_content_access

describe Aurita::Main::Category_Based_Content_Access do

  before do
    Category.delete_all
    User_Category.delete_all
  end

  it "respects content in public categories" do
    Lore::Transaction.exec { 
      content    = Content.create(:user_group_id => 1, :tags => [ :foo, :bar ])
      strategy   = Category_Based_Content_Access.new(content)
      user       = User_Group.get(1001)
      public_cat = Category.create(:category_name    => 'Public', 
                                   :public_readable  => true, 
                                   :public_writeable => true)

      strategy.permits_read_access_for(user).should == false
      strategy.permits_write_access_for(user).should == false
      
      content.add_category(public_cat)

      user.readable_category_ids.should_include(public_cat.category_id)
      content.category_ids.should_include(public_cat.category_id)
      user.may_view_category?(public_cat).should == true

      strategy.permits_read_access_for(user).should == true
      strategy.permits_write_access_for(user).should == true
    }
  end

  it "allows read access for category members with explicit read permissions in a content's category" do
    Lore::Transaction.exec { 
      content    = Content.create(:user_group_id => 1, :tags => [ :foo, :bar ])
      strategy   = Category_Based_Content_Access.new(content)
      user       = User_Group.get(1001)
      closed_cat = Category.create(:category_name        => 'Members only', 
                                   :registered_readable  => false, 
                                   :registered_writeable => false, 
                                   :public_readable      => false, 
                                   :public_writeable     => false)
      content.set_categories([])

      strategy.permits_read_access_for(user).should == false
      strategy.permits_write_access_for(user).should == false

      content.add_category(closed_cat)
      user.add_category(closed_cat, :write_permission => false, 
                                    :read_permission  => true)
      user.readable_category_ids.should_include(closed_cat.category_id)

      strategy.permits_read_access_for(user).should == true
      strategy.permits_write_access_for(user).should == false
    }
  end

  it "allows write access for category members with explicit write permissions in a content's category" do
    Lore::Transaction.exec { 
      content    = Content.create(:user_group_id => 1, 
                                  :tags          => [ :foo, :bar ])
      strategy   = Category_Based_Content_Access.new(content)
      user       = User_Group.get(1001)
      closed_cat = Category.create(:category_name        => 'Members only', 
                                   :registered_readable  => false, 
                                   :registered_writeable => false, 
                                   :public_readable      => false, 
                                   :public_writeable     => false)
      content.set_categories([])

      strategy.permits_read_access_for(user).should == false
      strategy.permits_write_access_for(user).should == false

      content.add_category(closed_cat)
      user.add_category(closed_cat, :write_permission => true, 
                                    :read_permission  => false)
      user.writeable_category_ids.should_include(closed_cat.category_id)

      strategy.permits_read_access_for(user).should == false
      strategy.permits_write_access_for(user).should == true
    }
  end

end
