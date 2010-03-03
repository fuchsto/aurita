

describe(Content_Permission) do

  it "maps Content instances to categories" do
  end

  it "provides helper method Content#add_category" do
    c   = Content.create(:user_group_id => 1, :tags => [ :spec, :test ])
    cat = Category.create(:category_name => 'Cat')
    c.category_ids.should_not_include(cat.category_id)
    c.add_category(cat)
    c.category_ids.should_include(cat.category_id)
  end

end
