require 'spec_helper'

describe "shopper product & category requests", :shopper => true do
  let!(:store) { Fabricate(:store) }
  let!(:product) { Fabricate(:product, store_id: store.id) }
  
  before(:each) do
    visit "/#{store.to_param}"
  end
  
  context "product page" do
    before(:each) do
      visit "/#{store.to_param}/products/#{product.to_param}"
    end
    context "when viewing the page" do
      it "display the product properly" do
        within "#main-content" do
          page.should have_selector "img"
          [product.title.to_s, "Add to Cart"].each do |cont|
            page.should have_content cont
          end
        end
      end
      it "does not have admin buttons" do
        within "#main-content" do
          ["Edit", "Retire", "Destroy"].each do |cont|
            page.should_not have_content cont
          end
        end
      end
      
      it "has the cart" do
        page.should have_selector "#cart-aside"
      end
      
      context "when multiple stores exist" do
        let!(:store_2)    { Fabricate(:store) }
        let!(:product_2)  { Fabricate(:product, store_id: store_2.id) }
        
        before(:each) do
          visit "/#{store_2.to_param}"
        end
        
        it "displays products for current store" do
          within "#main-content" do
            page.should have_content product_2.title
          end
        end
        
        it "does not display products for other stores" do
          within "#main-content" do
            page.should_not have_content product.title
          end          
        end
      end
    end
  end
  
  context "category page" do
    let!(:category) { Fabricate(:category, store_id: store.id) }
    
    before(:each) do
      product.categories << category
      # visit category_path(domain: store, id: category)
      visit "/#{store.to_param}/categories/#{category.to_param}"
    end
    
    it "has the proper content" do
      page.should have_content product.title
    end
    
    it "doesn't have admin stuff" do
      within "#main-content" do
        page.should_not have_content "Remove"
      end
    end
    
    it "has a cart" do
      page.should have_selector "#cart-aside"
    end
    
    context "when multiple stores exist" do
      let!(:store_2)    { Fabricate(:store) }
      let!(:product_2)  { Fabricate(:product, store_id: store_2.id) }
      let!(:category_2)  { Fabricate(:category, store_id: store_2.id) }
      let!(:product_3)  { Fabricate(:product, store_id: store_2.id) }
      let!(:category_3)  { Fabricate(:category, store_id: store_2.id) }
      
      before(:each) do
        product_2.categories << category_2
        product_3.categories << category_3
        visit "/#{store_2.to_param}/categories/#{category_2.to_param}"
      end
      
      it "displays products in the category for the current store" do
        within "#main-content" do
          page.should have_content product_2.title
        end
      end

      it "does not display products in other categories for the current store" do
        within "#main-content" do
          page.should_not have_content product_3.title
        end
      end
      
      it "does not display products for other stores" do
        within "#main-content" do
          page.should_not have_content product.title
        end          
      end
      
      context "in the header" do
        before(:each) do
          find("#menu1").click
        end
        
        it "shows categories for current store" do
          find("#menu1").text.should have_content category_2.name
          find("#menu1").text.should have_content category_3.name
        end
        
        it "does not show categories for other stores" do
          find("#menu1").text.should_not have_content category.name
        end
      end
    end
  end
end
