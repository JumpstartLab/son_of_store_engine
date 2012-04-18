require "spec_helper"
describe "Categories, dawg. For sorting and sheeeeeeeet" do
  let!(:categories) do
    c = []
    5.times { c << Fabricate(:category) }
    c
  end
  let!(:user) { Fabricate(:auth_user) }
  let(:category) { Fabricate(:category) }
  before(:each) do
    visit "/categories"
  end

  it "displays a link to each category" do
    categories.each do |category|
      page.should have_link("#{category.name}", :href => category_path(category))
    end
  end

  it "has valid category links" do
    if categories.first
      click_link_or_button("#{categories.first.name}")
      page.should have_content("#{categories.first.name}")
    end
  end

  it "has a link to create a new category" do
    page.should have_link("New", :href => "/categories/new")
  end

  context "category creation" do
    before(:each) do
      login_user_post("whatever@whatever.com", "admin")
    end

    it "creates a category" do
      visit new_category_path
      within("#new_category") do
        fill_in "category_name", with: "Chuckles"
      end

      click_link_or_button "Create Category"
      found = Category.all.select { |c| c.name == "Chuckles" }
      found.size.should == 1
    end

  end

end