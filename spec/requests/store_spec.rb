require 'spec_helper'

describe "Index" do
  context "as an unauthenticated user" do
    it "won't allow me to visit a pending store" do 
      visit store_path("testberry")
      current_path.should == stores_path
    end

    it "won't allow me to create a new store" do
      visit stores_path
      page.should_not have_content("Add new store")
    end
  end

  context "as a logged in user" do
    let(:user) { Factory(:user) }

    before(:each) do
      visit signin_path
      fill_in "email",        with: user.email
      fill_in "password",     with: user.password_confirmation
      click_button "Log in"
      visit stores_path
      click_link 'Add new store'
    end

    it "lets me create a new store for admin view only" do
      fill_in 'store_name', :with => 'Lingenberry'
      fill_in 'store_description', :with => 'Best berries ever.'
      fill_in 'store_slug', :with => 'lingenberry'
      click_button("Create")
      page.should_not have_content("Lingenberry")
      page.should have_content("Store waiting approval.")
    end

    it "won't allow me to duplicate stores" do
      fill_in 'store_name', :with => "Testberry"
      fill_in 'store_description', :with => "Berriest test of them all!"
      fill_in 'store_slug', :with => "testberry"
      click_button("Create")
      page.should have_content("Name has already been taken")
      page.should have_content("Slug has already been taken")
    end
  end
end