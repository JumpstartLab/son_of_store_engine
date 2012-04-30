require 'spec_helper'

describe "store admin for products", store_admin: true do
  let!(:store_owner)  { Fabricate(:user) }
  let!(:store)        { Fabricate(:store, creating_user_id: store_owner.id) }
  let!(:product)      { Fabricate(:product, store_id: store.id) }
  
  before(:each) do
    visit "/#{store.to_param}/products"
    click_link_or_button "Sign-In"
    login({email: store_owner.email_address, password: store_owner.password})
  end

  context "admin product view" do
    before(:each) do
      visit "/#{store.to_param}/admin/products"
    end

    it "has the proper header items" do
      within ".nav" do
        ["Categories", "My Account", "Logout"].each do |good|
          page.should have_content good
        end
        ["Sign-In", "Sign-Up"].each do |bad|
          page.should_not have_content bad
        end
      end
    end

    it "has admin buttons" do
      within "#main-content" do
        ["Edit", "Retire", "Destroy"].each do |button|
          page.should have_content button
        end
      end
    end

    it "can switch to user view" do
      find("#brand").click
      ["Edit", "Retire", "Destroy"].each do |button|
        page.should_not have_content button
      end
    end

    it "can switch back to admin view" do
      find("#brand").click
      admin_nav_go_to("products")
      ["Edit", "Retire", "Destroy"].each do |button|
        page.should have_content button
      end
    end
    
    it "displays information on the store product" do
      within "#main-content" do
        page.should have_content product.title
      end
    end
    
    it "can un-retire a product" do
      within "#main-content" do
        click_link_or_button "Retire"
      end
      within "#main-content" do
        click_link_or_button "Make Active Again"
      end
      page.should have_content "Retire"
    end
  
    context "when multiple stores exist" do
      let!(:store_2)    { Fabricate(:store) }
      let!(:product_2)  { Fabricate(:product, store_id: store_2.id) }
      
      before(:each) do
        visit "/#{store.to_param}/admin/products"
      end
      
      it "displays only the products for the current store" do
        within "#order-table" do
          page.should have_content product.title
        end
      end
      
      it "does not display products for other stores" do
        within "#order-table" do
          page.should_not have_content product_2.title
        end
      end
    end
  end

  context "product" do
    let!(:product) { Fabricate(:product, store_id: store.id) }

    before(:each) do
      visit "/#{store.to_param}/admin/products/#{product.to_param}"
    end

    it "has admin buttons" do
      ["Edit", "Retire", "Destroy"].each do |button|
        page.should have_content button
      end
    end

    it "can edit a product" do
      click_link_or_button "Edit"
      fill_in "Title", with: "Other Product"
      click_link_or_button "Update Product"
      within "#product-title" do
        page.should_not have_content product.title
        page.should have_content "Other Product"
      end
    end

    it "can destroy a product" do
      page.should have_selector "#product-title"
      click_link_or_button "Destroy"
      page.should_not have_selector "#product-title"
    end

    it "can retire a product" do
      click_link_or_button "Retire"
      find("#brand").click
      page.should_not have_content product.title
    end

    it "doesn't allow missing product information" do
      visit "/#{store.to_param}/admin/products/new"
      click_link_or_button "Create Product"
      current_path.should == "/#{store.to_param}/admin/products"
      page.should have_content "errors"
    end
  end
end
