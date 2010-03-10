
require('./spec_env')

Aurita::Main.import_model :content
Aurita::Main.import_model :content_category
Aurita::Main.import_model :strategies, :dacl_based_content_access

describe Aurita::Main::DACL_Based_Content_Access do


  before do
    User_DACL.delete_all
    User_Group_Hierarchy.delete_all
    Content_Hierarchy.delete_all
  end

  it "is a restrictive, discretionary access control based on mapping users to concrete permissions" do
    Lore::Transaction.exec { 
      content    = Content.create(:user_group_id => 1, :tags => [ :foo, :bar ])
      strategy   = DACL_Based_Content_Access.new(content)
      user       = User_Group.get(1001)

      strategy.permits_read_access_for(user).should == false
      strategy.permits_write_access_for(user).should == false

      strategy.grant(:user       => user, 
                     :permission => [ :r, :w ])

      strategy.permits_read_access_for(user).should == :explicit
      strategy.permits_write_access_for(user).should == :explicit
    }
  end

  it "provides inheritable permission sets (ACEs)" do
    Lore::Transaction.exec { 
      content    = Content.create(:user_group_id => 1, :tags => [ :spec, :test ])
      parent     = Content.create(:user_group_id => 1, :tags => [ :spec, :parent, :test ])
      parent.add_child(content)

      strategy   = DACL_Based_Content_Access.new(content)
      p_strategy = DACL_Based_Content_Access.new(parent)
      user       = User_Group.get(1001)

      strategy.permits_read_access_for(user).should == false
      strategy.permits_write_access_for(user).should == false

      p_strategy.grant(:user       => user, 
                       :inherit    => true, 
                       :permission => [ :r ])

      p_strategy.permits_read_access_for(user).should == :explicit
      p_strategy.permits_write_access_for(user).should == false
      strategy.permits_read_access_for(user).should == :inherit
      strategy.permits_write_access_for(user).should == false

      p_strategy.deny(:user       => user, 
                      :inherit    => true, 
                      :permission => [ :r ])

      p_strategy.permits_read_access_for(user).should == false
      p_strategy.permits_write_access_for(user).should == false
      strategy.permits_read_access_for(user).should == false
      strategy.permits_write_access_for(user).should == false

      p_strategy.grant(:user       => user, 
                       :permission => [ :r, :w ])

      p_strategy.permits_read_access_for(user).should == :explicit
      p_strategy.permits_write_access_for(user).should == :explicit
      strategy.permits_read_access_for(user).should == false
      strategy.permits_write_access_for(user).should == false

      p_strategy.grant(:user       => user, 
                       :inherit    => true, 
                       :permission => [ :r, :w ])

      strategy.permits_read_access_for(user).should == :inherit
      strategy.permits_write_access_for(user).should == :inherit
    }
  end

  it "allows permission sets for user groups" do
    Lore::Transaction.exec { 
      content    = Content.create(:user_group_id => 1, :tags => [ :spec, :test ])
      strategy   = DACL_Based_Content_Access.new(content)
      group      = User_Group.create(:user_group_name => 'Authors', 
                                     :atomic          => false)
      user       = User_Group.get(1001)
      group.add_member(user)

      user.user_group_id_stack.should == [ user.user_group_id, 
                                           group.user_group_id ]
 
      strategy.grant(:group      => group, 
                     :permission => [ :r, :w ], 
                     :inherit    => false)
 
      strategy.permits_read_access_for(user).should == :explicit
      strategy.permits_write_access_for(user).should == :explicit
    }
  end
  

end
