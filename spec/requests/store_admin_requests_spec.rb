require 'spec_helper'

describe "store_admin" do
  let!(:user) { Fabricate(:user) }
  let!(:product) { Fabricate(:product) }
  let!(:store) { Fabricate(:store) }
  before(:each) do
    user.update_attribute(:admin, true)
    user.update_attribute(:admin_view, true)
    visit store_path(store)
    click_link_or_button "Sign-In"
    login({email: user.email_address, password: user.password})
    visit store_admin_orders_path(store)
  end
  context "admin product view" do
    before(:each) do
      visit root_path
      admin_nav_go_to("products")
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
      click_link_or_button "The Urban Cyclist"
      ["Edit", "Retire", "Destroy"].each do |button|
        page.should_not have_content button
      end
    end
    it "can switch back to admin view" do
      click_link_or_button "The Urban Cyclist"
      admin_nav_go_to("products")
      ["Edit", "Retire", "Destroy"].each do |button|
        page.should have_content button
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
  end

  context "orders" do
    let!(:order) {
      ord = Fabricate(:order)
      ord.update_attributes({billing_method_id: nil, shipping_address_id: nil})
      ord
    }
    let!(:product) { Fabricate(:product) }
    let!(:line_item) {
      li = Fabricate(:line_item)
      li.update_attributes( { product_id: product.id, order_id: order.id} )
      li
    }
    before(:each) do
      other_user = Fabricate(:user)
      order.update_attribute(:user_id, other_user.id)
      visit admin_order_path(order)
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
      visit admin_orders_path
      click_link_or_button "Cancel"
      page.should have_content "cancelled"
    end
    it "can transition an order" do
      visit admin_orders_path
      click_link_or_button "Cancel"
      page.should have_content "cancelled"
    end
  end
  context "product" do
    let!(:product) { Fabricate(:product) }
    before(:each) do
      visit admin_product_path(product)
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
      click_link_or_button "The Urban Cyclist"
      page.should_not have_content product.title
    end
    it "doesn't allow missing product information" do
      visit new_admin_product_path
      click_link_or_button "Create Product"
      current_path.should == admin_products_path
      page.should have_content "errors"
    end
  end
  context "user" do
    let!(:other_user) { Fabricate(:user) }
    it "cannot edit another user's information" do
      visit admin_user_path(other_user)
      click_link_or_button "Change Profile"
      current_path.should == "/"
      page.should have_content "not allowed"
    end
    it "can view a list of users" do
      visit admin_users_path
      page.should have_content other_user.full_name
    end
  end
  context "category" do
    before(:each) do
      visit new_admin_category_path
      fill_in "Name", with: "baseballs"
      click_link_or_button "Create Category"
    end
    it "can create a category" do
      current_path.should have_content "baseballs"
    end
    it "can edit a category" do
      prod = Fabricate(:product)
      prod.categories << Category.last
      visit admin_categories_path
      click_link_or_button "Edit"
      fill_in "Name", with: "tennis equipment"
      click_link_or_button "Update Category"
      current_path.should == admin_category_path(Category.last)
      page.should_not have_content "baseballs"
      page.should have_content "tennis equipment"
    end
    it "can delete a category" do
      prod = Fabricate(:product)
      prod.categories << Category.last
      visit admin_categories_path
      click_link_or_button "Destroy"
      current_path.should == admin_categories_path
      page.should_not have_content "baseballs"
    end
  end
  context "dashboard" do
    context "filtering" do
      let!(:shipping) { Fabricate(:shipping_address) }
      let!(:billing) { Fabricate(:billing_method) }
      let!(:orders) {
        orders = []
        6.times do |i|
          orders[i] = Fabricate(:order)
          orders[i].update_attributes(user_id: nil, billing_method_id: billing.id, shipping_address_id: shipping.id)
        end
        orders
      }
      let!(:products) {
        products = []
        3.times do |i|
          products[i] = Fabricate(:product)
          products[i] = Fabricate(:product) until products[i].valid?
        end
        products
      }
      before(:each) do
        6.times do |i|
          line_item = Fabricate(:line_item)
          line_item.update_attributes(order_id: orders.sample.id,
            product_id: products.sample.id)
        end
        visit admin_orders_path
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
        visit root_path
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
       visit root_path
       click_link_or_button "Add to Cart"
       visit admin_order_path(Order.find_by_user_id(user.id))
       click_link_or_button "Add a Billing Method"
       add_billing(billing)
       visit admin_order_path(Order.find_by_user_id(user.id))
       click_link_or_button "Add a Shipping Address"
       add_shipping(shipping)
       click_link_or_button "Check Out"
       admin_nav_go_to("orders")
       click_link_or_button "Mark as 'shipped'"
       page.should have_content Order.last.action_time.first(10)
     end
   end
 end
end
