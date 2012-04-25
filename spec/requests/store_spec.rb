require 'spec_helper'

describe Store do
  context "user is managing stores" do
    let(:user) { FactoryGirl.create(:user) }
    it "allows a user to create a new store" do
      login(user) 
      visit profile_path 
      click_link "Create A Store"
      fill_in "Name", with: "Test Creation"
      fill_in "Slug", with: "test-slug"
      fill_in "Description", with: "Hello, World!"
      click_button "Create Store"
      page.should have_content("Test Creation")
      Store.last.name.should == "Test Creation"
      Store.last.status.should == "pending"
    end

    it "forbids a user from creating a store with existing name" do
      Store.create!(name: "Foo", slug: "www.bar.com", owner_id: :user_id)
      store_count = Store.count
      login(user) 
      visit profile_path 
      click_link "Create A Store"
      fill_in "Name", with: "Foo"
      fill_in "Slug", with: "test-slug"
      fill_in "Description", with: "Hello, World!"
      click_button "Create Store"
      page.should have_content("Name has already been taken")
      Store.count.should == store_count
    end

    it "forbids a user from creating a store with existing slug" do
      Store.create!(name: "Foo", slug: "www.bar.com", owner_id: :user_id)
      store_count = Store.count
      login(user) 
      visit profile_path 
      click_link "Create A Store"
      fill_in "Name", with: "Testes"
      fill_in "Slug", with: "www.bar.com"
      fill_in "Description", with: "Hello, World!"
      click_button "Create Store"
      page.should have_content("Slug has already been taken")
      Store.count.should == store_count
    end
  end
end