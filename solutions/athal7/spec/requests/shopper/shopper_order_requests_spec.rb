require 'spec_helper'

describe "shopper order requests", :shopper => true do
  let!(:user_1)           { Fabricate(:user) }
  let!(:billing_method)   { Fabricate(:billing_method, user: user_1) }
  let!(:shipping_address) { Fabricate(:shipping_address, user: user_1) }
  
  let!(:store_1)    { Fabricate(:store, domain: "store-1") }
  let!(:product_1)  { Fabricate(:product, store_id: store_1.id) }
  
  let!(:store_2)    { Fabricate(:store, domain: "store-2") }
  let!(:product_2)  { Fabricate(:product, store_id: store_2.id) }
  
  let!(:order_1)      { Fabricate(:order, user_id: user_1.id, store_id: store_1.id, status: "pending") }
  let!(:line_item_1)  { Fabricate(:line_item, product_id: product_1.id, order_id: order_1) }
  let!(:order_2)      { Fabricate(:order, user_id: user_1.id, store_id: store_2.id, status: "pending") }
  let!(:line_item_2)  { Fabricate(:line_item, product_id: product_2.id, order_id: order_2) }
  let!(:order_3)      { Fabricate(:order, user_id: user_1.id, store_id: store_1.id, status: "paid") }
  let!(:line_item_3)  { Fabricate(:line_item, product_id: product_2.id, order_id: order_3) }

  before(:each) do
    visit "/#{store_1.to_param}/products"
    click_link_or_button "Sign-In"
    login({email: user_1.email_address, password: user_1.password})
    visit "/#{store_1.to_param}/orders"
  end
  
  context "when the user has placed orders" do
    it "displays my orders for the current store" do
      page.should have_selector "#order_#{order_1.id}"
      page.should have_selector "#order_#{order_3.id}"
    end
    
    it "does not display my orders for other stores" do
      page.should_not have_selector "#order_#{order_2.id}"
    end
    
    context "when using the status filter" do
      context "after selecting a specific status" do
        before(:each) do
          select "pending", from: "status"
          click_button "Update"
        end
        
        it "displays only my orders with that status for the current store" do
          page.should have_selector "#order_#{order_1.id}"
        end

        it "does not display my orders with other statuses for the current store" do
          page.should_not have_selector "#order_#{order_3.id}"
        end

        it "does not display orders from other stores" do
          page.should_not have_selector "#order_#{order_2.id}"
        end
      end
      context "after selecting all order statuses" do
        before(:each) do
          select "all", from: "status"
          click_button "Update"
        end
        
        it "displays all of my orders for the current store" do
          page.should have_selector "#order_#{order_1.id}"
          page.should have_selector "#order_#{order_3.id}"
        end

        it "does not display orders from other stores" do
          page.should_not have_selector "#order_#{order_2.id}"
        end
      end
    end
  end
end