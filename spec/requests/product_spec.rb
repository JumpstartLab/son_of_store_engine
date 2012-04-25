require 'spec_helper'

describe "Product" do
  let!(:store) do
    FactoryGirl.create(:store)
  end
  before(:each) do
    Capybara.app_host = "http://#{store.id}.son.test"
  end
  let(:product) { FactoryGirl.create(:product, :store => store)}
  context "Logged Out" do
    it "can't create a new product" do
      visit new_store_admin_product_path
      page.should have_content("You must login first")
    end
    context "Browsing" do
      it "Browse all products" do
        visit products_path
        page.should have_content("Products")
      end
    end
  end
  context "Auth" do
    before(:each) do
      login(user)
    end
    context "User" do
      let!(:user) do
        FactoryGirl.create(:user, :password => "mike")
      end
      it "can't edit products" do
        visit edit_store_admin_product_path(product)
        page.should have_content("Must be an administrator")
      end
      it "can't create a new product" do
        visit new_store_admin_product_path
        page.should have_content("Must be an administrator")
      end
    end
    context "Admin" do
      let!(:user) do
        FactoryGirl.create(:admin, :password => "mike")
      end
      context "Product modification" do
        it "Edit Passes" do
          visit edit_store_admin_product_path(product)
          fill_in "product[name]", :with => "Mooo"
          click_on "Save Product"
          page.should have_content "Product updated."
        end
        it "Edit Fails" do
          visit edit_store_admin_product_path(product)
          page.should have_content("Edit Product")
          fill_in "product[name]", :with => ""
          click_on "Save Product"
          page.should have_content "can't be blank"          
        end
      end
      context "Creating a product" do
        it "can create a new product" do
          visit new_store_admin_product_path
          fill_in "product[name]", :with => "fooo123#{rand(2342342342)}"
          fill_in "product[description]", :with => "MY AWESOME PRODUCT"
          fill_in "product[price]", :with => "234"
          click_on "Save Product"
          page.should have_content "Product created."
        end
        it "validation fails" do
          visit new_store_admin_product_path
          fill_in "product[description]", :with => "MY AWESOME PRODUCT"
          fill_in "product[price]", :with => "234"
          click_on "Save Product"
          page.should have_content "can't be blank"
        end        
      end
      context "Removing a product" do
        let(:product2) { FactoryGirl.create(:product, :store => store)}
        it "Deletes a product" do
          product2
          visit store_admin_products_path
          save_and_open_page
          within("#product_#{product2.id}") do
            click_link("X")
          end
          page.should have_content("Product Removed")
        end
        it "Verify product isn't shown" do
          visit store_admin_products_path
          page.should_not have_content(product2.name)
        end
      end
    end
  end
end