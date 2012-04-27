require 'spec_helper'

describe "Products" do
  let!(:products) do
    (1..5).map { FactoryGirl.create(:product) }
  end
  let!(:retired_product) { FactoryGirl.create(:product, :activity => false) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:admin_user) { FactoryGirl.create(:user, :admin => true) }
  let!(:store) { FactoryGirl.create(:store) }

  describe "GET /products" do
    it "works! (now write some real specs)" do
      get store_products_path(products.first.store)
      response.status.should be(200)
    end
  end

  context "when I'm on the products page" do
    before(:each) { visit store_products_path(products.first.store) }
    it "does not display retired products" do
      visit store_products_path(products.first.store)
      page.should_not have_content(retired_product.title)
    end
  end

  context "editing products" do
    it "does not allow non-users to edit products" do
      visit(edit_store_product_path(products.first.store, products.first))
      page.should have_content("Not an admin")
    end

    it "doesn't allow non-admins to edit products" do
      login(user)
      visit(edit_store_product_path(products.first.store, products.first))
      page.should have_content("Not an admin")
    end

    it "allows admines to edit products" do
      login(admin_user)
      visit(edit_store_product_path(products.first.store, products.first))
      page.should have_content(products.first.title)
    end

    it "edits a product when admin" do
      login(admin_user)
      visit(edit_store_product_path(products.first.store, products.first))
      fill_in "product[title]", :with => "Lightsaber"
      click_on "Update Product"
      page.should have_content("Product updated.")
    end

    it "doesn't save non-valid product" do
      login(admin_user)
      visit(edit_store_product_path(products.first.store, products.first))
      fill_in "product[title]", :with => ""
      click_on "Update Product"
      page.should have_content "Image link"
    end
  end

  context "creating products" do
    it "does not allow non-users to create products" do
      visit(new_store_product_path(products.first.store))
      page.should have_content("Not an admin")
    end

    it "doesn't allow non-admins to create products" do
      login(user)
      visit(new_store_product_path(products.first.store))
      page.should have_content("Not an admin")
    end

    it "allows admins to create products" do
      login(admin_user)
      visit(new_store_product_path(products.first.store))
      page.should have_content("New Product")
    end

    it "saves a new product created by an admin" do
      login(admin_user)
      visit new_store_product_path(products.first.store)
      fill_in "product[title]", :with => "iPhone 5"
      fill_in "product[description]", :with => "Fancy new iphone"
      fill_in "product[price]", :with => "199.00"
      click_on "Create Product"
      page.should have_content "Product created."
    end

    it "validation fails" do
      login(admin_user)
      visit new_store_product_path(products.first.store)
      fill_in "product[description]", :with => "MY AWESOME PRODUCT"
      fill_in "product[price]", :with => "234"
      click_on "Create Product"
      page.should have_content "Image link"
    end 
  end

  context "searching products" do
    it "searches given a valid param" do
      visit store_products_path(products.first.store)
      fill_in "search", :with => products.first.title
      page.find('.search_button').click
      page.should have_content products.first.title
    end
  end
end
