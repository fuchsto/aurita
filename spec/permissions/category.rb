
require('../spec_env')

Aurita::Main.import_model :user_category
Aurita::Main.import_model :user_group
Aurita::Main.import_model :category
Aurita::Main.import_model :content_category


describe(Category) do
  before do
    Category.delete_all
    User_Category.delete_all
  end

  it "can be assigned to Content instances using model Content_Category and helper methods" do
    c   = Content.create(:user_group_id => 1, 
                         :tags          => [ :spec, :test ])
    cat = Category.create(:category_name => 'Cat')
    c.add_category(cat)

    c.category_ids.should_include(cat.category_id)
  end
  it "realizes guarding of Content instances" do
    c   = Content.create(:user_group_id => 1, 
                         :tags          => [ :spec, :test ])
    cat = Category.create(:category_name        => 'Cat', 
                          :registered_writeable => false, 
                          :registered_readable  => false, 
                          :public_readable      => false, 
                          :public_writeable     => false)
    c.add_category(cat)
    u1 = User_Group.get(1000)
    u1.may_view_category?(cat).should == false
    u1.may_view_category?(cat).should == false
    u1.may_edit_content?(c).should == false
    u1.may_view_content?(c).should == false
    User_Category.create(:user_group_id => u1.pkey, 
                         :category_id   => cat.pkey, 
                         :read_access   => true, 
                         :write_access  => false)
    u1.may_edit_content?(c).should == false
    u1.may_view_category?(cat).should == true
  end

end
