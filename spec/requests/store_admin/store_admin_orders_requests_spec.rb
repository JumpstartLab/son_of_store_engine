require 'spec_helper'

describe "store admin for orders", store_admin: true do
  let!(:user)     { Fabricate(:user) }
  let!(:store)    { Fabricate(:store, domain: "store-1") }
  let!(:product)  { Fabricate(:product, store_id: store.id) }
  
  before(:each) do
    user.update_attribute(:admin, true)
    user.update_attribute(:admin_view, true)
    visit "/#{store.to_param}/products"
    click_link_or_button "Sign-In"
    login({email: user.email_address, password: user.password})
  end
  
  context "orders" do
    let!(:order) {
      ord = Fabricate(:order, store_id: store.id)
      ord.update_attributes({billing_method_id: nil, shipping_address_id: nil})
      ord
    }
    let!(:product) { Fabricate(:product, store_id: store.id) }
    let!(:line_item) {
      li = Fabricate(:line_item)
      li.update_attributes( { product_id: product.id, order_id: order.id} )
      li
    }
    
    before(:each) do
      other_user = Fabricate(:user)
      order.update_attribute(:user_id, other_user.id)
      visit "/#{store.to_param}/admin/orders/#{order.to_param}"
    end
    
    it "can see another user's order" do
      current_path.should have_content "orders"
      page.should have_content product.title
    end
    
    it "cannot edit another user's billing on an order" do
      page.should_not have_content "Add a Billing Method"
    end
    
    it "cannot edit another user's shipping on an order" do
      page.should_not have_content "Add a Shipping Address"
    end
    
    it "can edit the quantity of a product on an order" do
      click_link_or_button "Update"
      page.should have_content "Quantity"
      fill_in "Quantity", with: "2"
      click_link_or_button "Update Quantity"
      within "#main-content" do
        page.should have_content "2"
      end
    end
    
    it "can cancel a pending order" do
      visit "/#{store.to_param}/admin/orders"
      click_link_or_button "Cancel"
      page.should have_content "cancelled"
    end
    
    it "can transition an order" do
      visit "/#{store.to_param}/admin/orders"
      click_link_or_button "Cancel"
      page.should have_content "cancelled"
    end
  end
  
  context "dashboard" do
    context "filtering" do
      let!(:shipping) { Fabricate(:shipping_address) }
      let!(:billing) { Fabricate(:billing_method) }
      let!(:orders) {
        orders = []
        6.times do |i|
          orders[i] = Fabricate(:order, store_id: store.id)
          orders[i].update_attributes(user_id: nil, billing_method_id: billing.id, shipping_address_id: shipping.id)
        end
        orders
      }
      let!(:products) {
        products = []
        3.times do |i|
          products[i] = Fabricate(:product, store_id: store.id)
          products[i] = Fabricate(:product, store_id: store.id) until products[i].valid?
        end
        products
      }
      
      before(:each) do
        6.times do |i|
          line_item = Fabricate(:line_item)
          line_item.update_attributes(order_id: orders.sample.id,
            product_id: products.sample.id)
        end
        visit "/#{store.to_param}/admin/orders"
      end
      
      it "displays all orders" do
        within "#main-content" do
          orders.each {|o| page.should have_content o.id}
        end
      end
      
      it "filters properly" do
        orders[0].update_attribute(:status, "paid")
        orders[1].update_attribute(:status, "shipped")
        orders[2].update_attribute(:status, "cancelled")
        orders[3].update_attribute(:status, "returned")
        orders[4].update_attribute(:status, "paid")
        ["pending","paid","shipped","cancelled","returned"].each do |option|
          select(option, from: "status")
          click_link_or_button "Update"
          within "#main-content" do
            orders.each do |ord|
              page.should have_content ord.id if ord.status == option
            end
          end
        end
        select("all", from: "status")
        click_link_or_button "Update"
        within "#main-content" do
          orders.each { |ord| page.should have_content ord.id }
        end
      end
      
      it "shows a timestamp of cancelled orders" do
        visit "/#{store.to_param}"
        click_link_or_button "Add to Cart"
        admin_nav_go_to("orders")
        click_link_or_button "Cancel"
        page.should have_content Order.last.action_time
      end
      
      it "shows a timestamp of shipped orders" do
        billing = { credit_card_number: "5555555555555555",
          month: "4",
          year: "2012",
          street: "One Mockingbird Lane",
          city: "Anytown",
          state: "Virginia",
          zipcode: "22209",
          card_type: 'Visa'
        }
        shipping = { street: "One Mockingbird Lane", city: "Anytown",
          state: "Virginia", email_address: "test@test.com", zipcode: "22209", name: "Favorite Shipping"
        }
        visit "/#{store.to_param}"
        click_link_or_button "Add to Cart"
        order = Order.where(user_id: user.id).first
        visit "/#{store.to_param}/admin/orders/#{order.to_param}"
        click_link_or_button "Add a Billing Method"
        add_billing(billing)
        visit "/#{store.to_param}/admin/orders/#{order.to_param}"
        click_link_or_button "Add a Shipping Address"
        add_shipping(shipping)
        click_link_or_button "Check Out"
        admin_nav_go_to("orders")
        click_link_or_button "Mark as 'shipped'"
        page.should have_content Order.last.action_time.first(10)
      end
      
      context "when multiple stores exist" do
        let!(:store_2)    { Fabricate(:store, domain: "store-2") }
        let!(:product_2)  { Fabricate(:product, store_id: store_2.id) }
        
        let!(:store_2_orders) {
          orders = []
          6.times do |i|
            orders[i] = Fabricate(:order, store_id: store_2.id)
            orders[i].update_attributes(user_id: nil, billing_method_id: billing.id, shipping_address_id: shipping.id)
          end
          orders
        }
        let!(:store_2_products) {
          products = []
          3.times do |i|
            products[i] = Fabricate(:product, store_id: store_2.id)
            products[i] = Fabricate(:product, store_id: store_2.id) until products[i].valid?
          end
          products
        }

        before(:each) do
          6.times do |i|
            line_item = Fabricate(:line_item)
            line_item.update_attributes(order_id: store_2_orders.sample.id,
              product_id: store_2_products.sample.id)
          end
          visit "/#{store.to_param}/admin/orders"
        end
        
        it "displays orders for the current store" do
          orders.each { |store_order| page.should have_selector "#order_#{store_order.id}" }
        end
        
        it "does not display orders for other stores" do
          store_2_orders.each { |store_order| page.should_not have_selector "#order_#{store_order.id}" }
        end
      end
    end
  end
end