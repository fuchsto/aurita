
require('./spec_env')
Aurita::Main.import_model :content_hierarchy

describe Aurita::Main::Content_Hierarchy do

  it "realized a simple, unordered tree of content instances" do

    root = Content.create(:user_group_id => 1, 
                          :tags          => [ :root ])
    sub_1 = Content.create(:user_group_id => 1, 
                           :tags          => [ :sub_1 ])
    sub_2 = Content.create(:user_group_id => 1, 
                           :tags          => [ :sub_2 ])
    sub_1_1 = Content.create(:user_group_id => 1, 
                             :tags          => [ :sub_1_1 ])
    sub_1_2 = Content.create(:user_group_id => 1, 
                             :tags          => [ :sub_1_2 ])

    root.add_child(sub_1)
    root.add_child(sub_2)
    sub_1.add_child(sub_1_1)
    sub_1.add_child(sub_1_2)

    sub_1_2.content_id_stack.should == [ sub_1_2.content_id, 
                                         sub_1.content_id, 
                                         root.content_id ]

    orphan = Content.create(:user_group_id => 1, 
                            :tags          => [ :spec, :orphan ])
    orphan.content_id_stack.should == [ orphan.content_id ] 
  end


end
