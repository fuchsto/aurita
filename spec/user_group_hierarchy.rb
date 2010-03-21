
require('./spec_env')
Aurita::Main.import_model :user_group_hierarchy


describe Aurita::Main::User_Group_Hierarchy do

  before do
    User_Group_Hierarchy.delete_all
  end

  it "realizes a simple, unordered tree of user groups" do
    Lore::Transaction.exec { 
      root    = User_Group.create(:user_group_name => 'Root', :atomic => false)
      sub_1   = User_Group.create(:user_group_name => 'Sub 1', :atomic => false)
      sub_2   = User_Group.create(:user_group_name => 'Sub 2', :atomic => false)
      sub_1_1 = User_Group.create(:user_group_name => 'Sub 1 1', :atomic => false)
      sub_1_2 = User_Group.create(:user_group_name => 'Sub 1 2', :atomic => false)

      sub_1.add_group(sub_1_1)
      sub_1.add_group(sub_1_2)
      root.add_group(sub_1)
      root.add_group(sub_2)

      user_1  = User_Group.get(1001)
      user_2  = User_Group.get(100)

      sub_1.add_member(user_1)
      sub_1_2.add_member(user_2)
      sub_2.add_member(user_2)

      user_2.user_group_id_stack.should == [ user_2.user_group_id, 
                                             sub_1_2.user_group_id, 
                                             sub_2.user_group_id, 
                                             sub_1.user_group_id, 
                                             root.user_group_id ]

      user_1.user_group_id_stack.should == [ user_1.user_group_id, 
                                             sub_1.user_group_id, 
                                             root.user_group_id ]
      
    }
  end


end
