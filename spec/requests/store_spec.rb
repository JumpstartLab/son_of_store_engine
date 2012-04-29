require 'spec_helper'

describe Store do
  context "user is managing an existing store" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:store) { FactoryGirl.create(:store) }
    it "disallows a nonprivileged user from editing a store" do
      login(user)
      visit edit_store_path(store)
      page.current_path.should == store_products_path(store)
    end

    it "disallows a stocker from editing a store" do
      stocker = FactoryGirl.create(:user)
      stocker.promote(store, :stocker)
      login(stocker)
      visit edit_store_path(store)
      page.current_path.should == store_products_path(store)
    end

    it "disallows a guest from editing a store" do
      visit edit_store_path(store)
      page.current_path.should == new_session_path
    end

    it "allows a manager to edit a store" do
      manager = FactoryGirl.create(:user)
      manager.promote(store, :manager)
      login(manager)
      visit edit_store_path(store)
      page.current_path.should == edit_store_path(store)
    end

    it "allows an admin to edit a store" do
      user.update_attribute(:admin, true)
      login(user)
      visit edit_store_path(store)
      page.current_path.should == edit_store_path(store)
    end
  end
  context "user is creating stores" do
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