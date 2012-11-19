require 'spec_helper'

describe "shopper order requests", :shopper => true do
  let!(:user_1)           { Fabricate(:user) }
  let!(:billing_method)   { Fabricate(:billing_method, user: user_1) }
  let!(:shipping_address) { Fabricate(:shipping_address, user: user_1) }
  
  let!(:store_1)    { Fabricate(:store, domain: "store-1") }
  let!(:product_1)  { Fabricate(:product, store_id: store_1.id) }
  
  let!(:store_2)    { Fabricate(:store, domain: "store-2") }
  let!(:product_2)  { Fabricate(:product, store_id: store_2.id) }
  
  let!(:order_1)      { Fabricate(:order, user_id: user_1.id, store_id: store_1.id) }
  let!(:line_item_1)  { Fabricate(:line_item, product_id: product_1.id, order_id: order_1) }
  let!(:order_2)      { Fabricate(:order, user_id: user_1.id, store_id: store_2.id) }
  let!(:line_item_2)  { Fabricate(:line_item, product_id: product_2.id, order_id: order_2) }

  before(:each) do
    visit "/#{store_1.to_param}/products"
    click_link_or_button "Sign-In"
    login({email: user_1.email_address, password: user_1.password})
    visit "/#{store_1.to_param}/orders"
  end
  
  context "when the user has placed orders" do
    it "displays my orders for the current store" do
      page.should have_selector "#order_#{order_1.id}"
    end
    
    it "displays my orders for other stores" do
      page.should_not have_selector "#order_#{order_2.id}"
    end
  end
end