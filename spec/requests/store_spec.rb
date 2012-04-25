require 'spec_helper'

describe "Index" do

  let!(:test_store) { Factory(:store) }

  context "as a logged in user" do

    before (:each) do
      visit stores_path
      click_link 'Add new store'
    end

    it "lets me create a new store for admin view only" do
      fill_in 'store_name', :with => 'Lingenberry'
      fill_in 'store_description', :with => 'Best berries ever.'
      fill_in 'store_slug', :with => 'lingenberry'
      click_button("Create")
      page.should_not have_content("Lingenberry")
    end

    it "won't allow me to duplicate stores" do
      fill_in 'store_name', :with => test_store.name
      fill_in 'store_description', :with => test_store.description
      fill_in 'store_slug', :with => test_store.slug
      click_button("Create")
      page.should have_content("Name has already been taken")
      page.should have_content("Slug has already been taken")
    end
  end

  context "as an unauthenticated user" do

    it "won't allow me to visit a pending store" do 
      visit store_path(test_store.slug)
      current_path.should == stores_path
    end
  end
end