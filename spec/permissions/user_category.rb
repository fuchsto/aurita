
require('../spec_env')

Aurita::Main.import_model :user_category
Aurita::Main.import_model :user_group
Aurita::Main.import_model :category

describe(Aurita::Main::User_Category) do
  before do
    Category.delete_all
    User_Category.delete_all
  end

  it "maps n protected categories to m users, implementing an immediate membership" do
    Lore::Transaction.exec { |tx|
      u1 = User_Group.get(1000)
      u2 = User_Group.get(1001)
      c1 = Category.create(:category_name        => 'C1', 
                           :registered_writeable => false, 
                           :registered_readable  => false, 
                           :public_readable      => false, 
                           :public_writeable     => false)
      c2 = Category.create(:category_name        => 'C2', 
                           :registered_writeable => false, 
                           :registered_readable  => false, 
                           :public_readable      => false, 
                           :public_writeable     => false)

      User_Category.create(:user_group_id => u1.pkey,
                           :category_id   => c1.pkey)
      User_Category.create(:user_group_id => u1.pkey,
                           :category_id   => c2.pkey)

      u1.member_of_category?(c1).should == true
      u1.member_of_category?(c2).should == true
      u2.member_of_category?(c1).should == false
      u2.member_of_category?(c2).should == false

      u1.may_view_category?(c1).should == true
      u2.may_view_category?(c1).should == false
    }
  end

  it "defines read-access to a category" do
    Lore::Transaction.exec { |tx|
      u1 = User_Group.get(1010) # Member, read access
      u2 = User_Group.get(1011) # Member, but no read access
      u3 = User_Group.get(1012) # No member

      c1 = Category.create(:category_name        => 'C1', 
                           :registered_writeable => false, 
                           :registered_readable  => false, 
                           :public_readable      => false, 
                           :public_writeable     => false)
      User_Category.create(:user_group_id   => u1.pkey,
                           :read_permission => true, 
                           :category_id     => c1.pkey)
      User_Category.create(:user_group_id   => u2.pkey,
                           :read_permission => false, 
                           :category_id     => c1.pkey)
      u1.may_view_category?(c1).should == true
      u2.may_view_category?(c1).should == false
      u3.may_view_category?(c1).should == false
    }
  end

  it "defines write-access to a category" do
    Lore::Transaction.exec { |tx|
      u1 = User_Group.get(1010) # Member, read access
      u2 = User_Group.get(1011) # Member, but no read access
      u3 = User_Group.get(1012) # No member

      c1 = Category.create(:category_name        => 'C1', 
                           :registered_writeable => false, 
                           :registered_readable  => false, 
                           :public_readable      => false, 
                           :public_writeable     => false)
      User_Category.create(:user_group_id    => u1.pkey,
                           :write_permission => true, 
                           :category_id      => c1.pkey)
      User_Category.create(:user_group_id    => u2.pkey,
                           :write_permission => false, 
                           :category_id      => c1.pkey)
      u1.may_write_to_category?(c1).should == true
      u2.may_write_to_category?(c1).should == false
      u3.may_write_to_category?(c1).should == false
    }
  end

end
