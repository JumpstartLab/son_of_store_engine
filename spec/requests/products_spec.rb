require 'spec_helper'

describe "Products", :requests => :products do
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
      page.should have_content("You do not have management privileges for #{products.first.store.name}")
    end

    it "doesn't allow non-admins to edit products" do
      login(user)
      visit(edit_store_product_path(products.first.store, products.first))
      page.should have_content("You do not have management privileges for #{products.first.store.name}")
    end

    it "allows admines to edit products" do
      login(admin_user)
      visit(edit_store_product_path(products.first.store, products.first))
      page.should have_content(products.first.title)
    end

    it "redirects to the admin dashboard" do
      login(admin_user)
      visit(edit_store_product_path(products.first.store, products.first))
      fill_in "product[title]", :with => "Lightsaber"
      click_on "Update Product"
      page.current_path.should == store_dashboard_path(products.first.store)
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
      page.should have_content("You do not have management privileges for #{products.first.store.name}")
    end

    it "doesn't allow non-admins to create products" do
      login(user)
      visit(new_store_product_path(products.first.store))
      page.should have_content("You do not have management privileges for #{products.first.store.name}")
    end

    it "allows admins to create products" do
      login(admin_user)
      visit(new_store_product_path(products.first.store))
      page.should have_content("New Product")
    end

    it "redirects to the dashboard" do
      login(admin_user)
      visit new_store_product_path(products.first.store)
      fill_in "product[title]", :with => "iPhone 5"
      fill_in "product[description]", :with => "Fancy new iphone"
      fill_in "product[price]", :with => "199.00"
      click_on "Create Product"
      page.current_path.should == store_dashboard_path(products.first.store)
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
      fill_in "_search", :with => products.first.title
      page.find('.search-button').click
      page.should have_content products.first.title
    end
  end

  context "when store is disabled", :requests => :disabled_store do
    let(:store) { products.first.store }

    before(:each) do
      store.disable!      
    end

    context "visiting main store page" do
      it "shows store under maintenance" do
        visit store_products_path(store)
        page.should_not have_content(products.first.title)
      end
    end
  end

  context "stockers logged in to stocker_dashboard", :austen => :fart do
    let!(:user6) { FactoryGirl.create(:user) }
    let!(:store4) { FactoryGirl.create(:store) }
    
    it "allows stocker to add a product" do
      user6.promote(store4, 'stocker')
      login(user6)

      visit store_stocker_dashboard_path(store4)
      click_on 'Add Product'
      current_path.should == new_store_product_path(store4)
    end
  end
end
