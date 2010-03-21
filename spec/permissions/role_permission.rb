
require('./spec_env')
Aurita::Main.import_model :role_permission

describe Aurita::Main::Role_Permission do

  before do
    Role_Permission.delete_all
    Role.delete_all
  end

  it "should belong to a role instance" do
    Lore::Transaction.exec { 
      role_1         = Role.create(:role_name => :spec_role)
      role_perm      = Role_Permission.create(:role_id => role_1.role_id)
      role_perm.role.should == role_1

      role_2         = Role.create(:role_name => :other_role)
      role_perm.role = role_2
      role_perm.role.should == role_2
      role_perm.commit

      role_perm_cp   = Role_Permission.get(role_perm.role_permission_id)
      role_perm_cp.role.should == role_2
    }
  end

  it "maps a single permission entry to its role" do
    Lore::Transaction.exec { 
      role        = Role.create(:role_name => :spec_role)
      role_perm_1 = Role_Permission.create(:role_id => role.role_id, 
                                           :name    => 'plant_trees', 
                                           :value   => true)
      role_perm_2 = Role_Permission.create(:role_id => role.role_id, 
                                           :name    => 'talk_to_strangers', 
                                           :value   => false)

      role_perm_1.role.should == role
      role_perm_2.role.should == role

      role_perm_1.name.should == 'plant_trees'
      role_perm_1.value.should == true
      role_perm_2.name.should == 'talk_to_strangers'
      role_perm_2.value.should == false
    } 
  end
  
  it "extends model User_Group by helpers to resolve an instances permissions" do
    Lore::Transaction.exec { 
      role        = Role.create(:role_name => :spec_role)
      role_perm_1 = Role_Permission.create(:role_id => role.role_id, 
                                           :name    => :eat_candy, 
                                           :value   => true)
      role_perm_2 = Role_Permission.create(:role_id => role.role_id, 
                                           :name    => :eat_worms, 
                                           :value   => false)
      user = User_Group.get(1001)
      map  = User_Role.create(:user_group_id => user.user_group_id, 
                              :role_id       => role.role_id)

      user.may(:eat_candy).should == true
      user.may(:eat_worms).should == false
    }
  end

end
