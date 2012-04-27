require 'spec_helper'

describe "sorting by categories" do
  let!(:products) do
    (1..5).map { FactoryGirl.create(:product) }
  end
  let!(:category) { FactoryGirl.create(:category) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:admin_user) { FactoryGirl.create(:user, :admin => true) }

  context "creating categories" do
    it "does not allow non-users to create categories" do
      visit new_store_category_path(category.store, category)
      page.should have_content("Not an admin")
    end

    it "does not allow non-admin to create categories" do
      login(user)
      visit new_store_category_path(category.store, category)
      page.should have_content("Not an admin")
    end

    it "allows admins to create categories" do
      login(admin_user)
      visit new_store_category_path(category.store, category)
      page.should have_content("Title")
    end

    it "saves a new category created by admin" do
      login(admin_user)
      visit new_store_category_path(category.store, category)
      fill_in "category[title]", :with => "Comfy"
      click_on "Create Category"
      page.should have_content "Categories all the way down!"
    end

    it "doesn't save an invalid category name" do
      login(admin_user)
      visit new_store_category_path(category.store, category)
      fill_in "category[title]", :with => ""
      click_on "Create Category"
      page.should have_content "can't"
    end
  end

  context "editing categories" do
    it "does not allow non-users to edit categories" do
      visit(edit_store_category_path(category.store, category))
      page.should have_content("Not an admin")
    end

    it "does not allow non-admin to edit categories" do
      visit(edit_store_category_path(category.store, category))
      page.should have_content("Not an admin")
    end

    it "allows admins to edit categories" do
      login(admin_user)
      visit(edit_store_category_path(category.store, category))
      page.should have_content("Edit Category")
    end

    it "edits a category when admin" do
      login(admin_user)
      visit(edit_store_category_path(category.store, category))
      fill_in "category[title]", :with => "Frumpy"
      click_on "Update Category"
      page.should have_content("Category updated.")
    end

    it "prevents edits for bad categories" do
      login(admin_user)
      visit(edit_store_category_path(category.store, category))
      fill_in "category[title]", :with => ""
      click_on "Update Category"
      page.should have_content("can't")
    end
  end

  context "viewing categories" do
    let(:category) { FactoryGirl.create(:category, store: products.first.store) }
    it "appears on the homepage" do
      visit store_products_path(products.first.store)
      click_on category.title
      page.should have_content("Products by #{category.title}")
    end

    it "loads one category for the category" do
      visit store_category_path(category.store, category)
      page.should have_content("Products by #{category.title}")
    end
  end
end

