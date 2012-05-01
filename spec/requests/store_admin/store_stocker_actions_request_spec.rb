require 'spec_helper'

describe "Store Stocker Actions", store_stocker: true do
  let!(:store_stocker)  { Fabricate(:user) }
  let!(:store)          { Fabricate(:store) }
  let!(:stocker_permit) { Fabricate(:store_stocker_permission, store_id: store.id, user_id: store_stocker.id) }
  let!(:product_to_be_retired)  { Fabricate(:product, store_id: store.id) }
  let!(:product_to_be_edited)   { Fabricate(:product, store_id: store.id) }
  let!(:products)               { [product_to_be_retired, product_to_be_edited] }
  
  before(:each) do
    visit root_path
    click_link_or_button "Sign-In"
    login(email: store_stocker.email_address, password: store_stocker.password)
  end
  
  context "when viewing the admin listing of products" do
    before(:each) do
      visit "/#{store.to_param}/admin/products"
    end
    
    it "displays a the list of products" do
      products.each do |product|
        page.should have_selector "#product_#{product.id}"
      end
    end
  end

  context "when adding a product" do
    before(:each) do
      visit "/#{store.to_param}/admin/products"
      click_link_or_button "New"
      fill_in "Title", :with => "Brand New Product"
      fill_in "Description", :with => "This is a product.  And it is brand new!"
      fill_in "Price", :with => "100.50"
      fill_in "Photo url", :with => "http://www.google.com/images/srpr/logo3w.png"
    end
    
    it "creates a new product" do
      expect { click_button "Create Product" }.to change{ Product.count }.by(1)
    end
    
    it "displays the list of products" do
      click_button "Create Product"
      current_path.should == "/#{store.to_param}/admin/products"
      products_with_new = products
      products_with_new << Product.where(title: "Brand New Product").first
      products_with_new.each do |product|
        page.should have_selector "#product_#{product.id}"
      end
    end
    
    it "displays the information for the new product" do
      click_button "Create Product"
      within "#product_#{Product.where(title: "Brand New Product").first.id}" do
        page.should have_content "Brand New Product"
        page.should have_content "100.50"
        page.should have_content "active"
      end
    end
    
    it "displays a confirmation flash message" do
      click_button "Create Product"
      page.should have_content "Product was successfully created."
    end    
  end

  context "when editing a product" do
    context "from store admin products view" do 
      before(:each) do
        visit "/#{store.to_param}/admin/products"
        within "#product_#{product_to_be_edited.id}" do
          click_link_or_button "Edit"
        end
        fill_in "Title", :with => "Old Edited Product"
        fill_in "Description", :with => "This is an old product.  And it has been edited!"
        fill_in "Price", :with => "112.50"
        fill_in "Photo url", :with => "http://www.google.com/images/nav_logo107.png"
        click_link_or_button "Update Product"
      end
      
      it "displays a the list of products" do
        current_path.should == "/#{store.to_param}/admin/products"
        products.each do |product|
          page.should have_selector "#product_#{product.id}"
        end
      end
      
      it "displays the updated information for the product" do
        within "#product_#{product_to_be_edited.id}" do
          page.should have_content "Old Edited Product"
          page.should have_content "112.50"
        end
      end
      
      it "displays a confirmation flash message that the product has been updated" do
        page.should have_content "\'Old Edited Product\' has been updated"
      end
    end
  end
  
  context "when retiring a product" do
    context "from store admin products view" do 
      before(:each) do
        visit "/#{store.to_param}/admin/products"
        within "#product_#{product_to_be_retired.id}" do
          click_link_or_button "Retire"
        end
      end
      
      it "displays a the list of products" do
        current_path.should == "/#{store.to_param}/admin/products"
        products.each do |product|
          page.should have_selector "#product_#{product.id}"
        end
      end
      
      it "retires that product" do
        within "#product_#{product_to_be_retired.id}" do
          page.should have_content "retired"
        end
      end
      
      it "displays a confirmation flash message that the product was retired" do
        page.should have_content "\'#{product_to_be_retired.title}\' was retired"
      end
    end
  end
end