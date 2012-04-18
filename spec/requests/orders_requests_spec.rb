require 'spec_helper'

describe "Orders Requests" do
  let!(:admin_user) { Fabricate(:auth_user, :id => 1) }
  let!(:user) { Fabricate(:user, :id => 2) }
  let!(:customer) { Fabricate(:customer, :user_id => 1) }
  let!(:customer2) { Fabricate(:customer, :user_id => 2) }
  let!(:order1) { Fabricate(:order, :id => 1, :customer_id => 2, :status => "shipped") }
  let!(:order2) { Fabricate(:order, :id => 2, :customer_id => 1, :status => "pending") }
  let!(:order3) { Fabricate(:order, :customer_id => 1, :status => "pending") }
  let!(:order4) { Fabricate(:order, :customer_id => 1, :status => "paid") }
  let!(:order_item1) { Fabricate(:order_item, :order_id => 1, :product_id => 1) }
  let!(:order_item2) { Fabricate(:order_item, :order_id => 1, :product_id => 2) }
  let!(:product1) { Fabricate(:product, :id => 1) }
  let!(:product2) { Fabricate(:product, :id => 2) }
  let(:products) { [product1, product2] }

  before(:each) do
    visit login_path
    fill_in('Email', :with => admin_user.email)
    fill_in('Password', :with => "admin")
    click_button('Log in')

    OrdersController.any_instance.stub(:current_user).and_return(admin_user)

    visit orders_path
  end

  context "index" do
    it "lists all orders" do
      Order.all.each do |order|
        page.should have_content(order.customer.user.name)
      end
    end

    it "lists the number of orders for each status" do
      within("div#filters") do
        page.should have_content("Pending: 2")
      end
    end

    it "lists each product ordered for each order" do
      page.should have_content(product1.title)
      page.should have_content(product2.title)
    end

    it "links to the individual product pages" do
      page.should have_link(product1.title, :href => product_path(product1))
      page.should have_link(product2.title, :href => product_path(product2))
    end

    context "order status is pending" do
      it "shows a link to 'cancel' orders" do
        within("tr#order_2") do
          page.should have_link("Cancel Order")
          page.should_not have_link("Mark As Returned")
          page.should_not have_link("Mark As Shipped")
        end
      end
      it "changes the order status to canceled when clicked" do
        within("tr#order_2") do
          click_link("Cancel Order")
        end
        within("tr#order_2") do
          page.should have_content("Canceled")
        end
      end
    end

    context "order status is shipped" do
      it "shows a link to 'mark as returned' orders" do
        within("tr#order_1") do
          page.should have_link("Mark As Returned")
          page.should_not have_link("Mark As Shipped")
          page.should_not have_link("Cancel Order")
        end
      end

      it "changes the order status to returned when clicked" do
        within("tr#order_1") do
          click_link("Mark As Returned")
        end
        within("tr#order_1") do
          page.should have_content("Returned")
        end
      end
    end

    context "CRUD" do
      it "shows the created order" do
        visit order_path(order2)
        page.should have_content(order2.total)
      end

      it "creates a new order from form" do
        visit new_order_path
      end
    end

    context "search" do
      it "matches searched terms" do
        order1.products = products
        p = order1.matches("#{products.first.title}")
      end
    end

    context "order status is paid" do
      it "shows a link to 'mark as shipped' orders" do
        within("tr#order_4") do
          page.should have_link("Mark As Shipped")
          page.should_not have_link("Cancel Order")
          page.should_not have_link("Mark as Returned")
        end
      end
      it "changes the order status to shipped when clicked" do
        within("tr#order_4") do
          click_link("Mark As Shipped")
        end
        within("tr#order_4") do
          page.should have_content("Shipped")
        end
      end
    end
  end 

  context "filtered index" do
    it "lists orders only for that category" do
      within("div#filters") do
        click_link("Pending")        
      end
      page.should have_content(order2.user.name)
      page.should_not have_content(order1.user.name)
    end
  end
end