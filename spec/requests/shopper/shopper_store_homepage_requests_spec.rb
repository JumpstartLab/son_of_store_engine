require 'spec_helper'

describe "shopper" do
  let!(:store) { Fabricate(:store) }
  let!(:product) { Fabricate(:product, store_id: store.id) }
  context "index" do
    before(:each) do
      visit "/#{store.to_param}"
    end
    context "homepage layout" do
      context "header" do
        it "has the proper header" do
          page.should have_content "The Urban Cyclist"
          page.should have_content "Categories"
          page.should have_content "Sign-In"
          page.should have_content "Sign-Up"
        end
      end
      it "has a clickable listing of products" do
        page.should have_selector "##{dom_id(product)}"
        click_link_or_button product.title
        current_path.should == "/#{store.to_param}/products/#{product.to_param}"
      end
      it "has a clickable list of product categories" do
        category = Fabricate(:category, store_id: store.id)
        product.categories << category
        visit "/#{store.to_param}/products"
        within "#main-content" do
          page.should have_content category.name
          click_link_or_button category.name
          current_path.should == "/#{store.to_param}/categories/#{category.to_param}"
        end
      end
      it "searches products by their title" do
        page.should have_content "Reset"
        fill_in "filtered", with: product.title
        click_link_or_button "Find"
        page.should have_content product.title
      end

      it "has an add to cart button" do
        page.should have_content "Add to Cart"
      end
      it "does not have admin buttons" do
        page.should_not have_content "Edit"
        page.should_not have_content "Retire"
        page.should_not have_content "Destroy"
      end
    end
  end
  
end
