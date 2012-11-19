require 'spec_helper'
 include ActionView::Helpers::NumberHelper

describe 'using the shopping cart' do
  let(:user) { FactoryGirl.create(:user) }
  let(:product) { FactoryGirl.create(:product) }
  context "When I'm on a product page" do
    
    before(:each) { visit store_product_path(product.store, product) }

    context "and I click add to cart" do
      before(:each) { click_link_or_button "Add to Cart" }

      it "takes me to the cart page" do
        page.should have_css('h1', :text => 'Cart')
      end

      it "shows the product in my cart" do
        within("#cart") do
          page.should have_content(product.title)
        end
      end
      
      context "when I already have that item in a cart" do
        before(:each) { visit store_product_path(product.store, product) }
        before(:each) { click_link_or_button "Add to Cart" }

        it "increases the quantity for an existing item" do
          page.should have_content("2 items")
        end

        it "should list only one copy of the item" do
          page.should_not have_selector('a', :href => 
            store_product_path(product.store, product), :count => 2)
        end
      end 
    end
  end

  context "when I have a cart" do
    it "combines carts" do
      login(user)
      visit store_product_path(product.store, product)
      click_link_or_button "Add to Cart"
      click_on "Log Out"
      visit store_product_path(product.store, product)
      click_link_or_button "Add to Cart"
      login(user)
      visit store_product_path(product.store, product)
      click_on "Cart"
      page.should have_content "2 items"
    end
  end

  context "when I'm on a product page" do
    let(:product) { FactoryGirl.create(:product, :activity => false) }
    it "prevents me from adding a retired product to cart" do
      visit store_product_path(product.store, product)
      click_on "Add to Cart"
      page.should have_content("Sorry, this product is retired.")
    end
  end

  context "when I'm on the cart" do
    let!(:store) { FactoryGirl.create(:store) }
    let(:products) do
      (1..5).map { FactoryGirl.create(:product, store: store) }
    end
    let(:test_cart) { FactoryGirl.create(:cart, :products => products, store: store) }
    before(:each) { load_cart_with_products(products) }

    it "removes the item when I click remove" do
      within("#product_#{test_cart.cart_items.last.product.id}") do
        click_link_or_button "Remove item"
      end
      page.should_not have_content(products.last.title)
    end

    it "shows the total price of the items" do
      visit store_cart_path(store, test_cart)
      page.should have_content(number_to_currency(test_cart.total_price))
    end

    it "shows the total price for each item" do
      product = FactoryGirl.create(:product) 
      n = rand(2..100)
      n.times { load_cart_with_products([product]) }
      page.should have_content(number_to_currency(product.price * n))
    end

    it "lets me update quantity of the items" do
      within("#product_#{products.first.id}") do
        click_link_or_button "Edit Quantity"
      end
      fill_in "cart_item_quantity", :with => "96"
      click_on "Update Cart item"
      page.should have_content("96")
    end
  end
end
