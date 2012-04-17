require 'spec_helper'

describe "Orders Requests" do
  let!(:product1) { Fabricate(:product, :id => 1) }
  let!(:product2) { Fabricate(:product, :id => 2) }
  let!(:user1) { Fabricate(:user, :id => 1, :email => "ham@gmail.com", :name => "Fred Banks") }
  let!(:user2) { Fabricate(:user, :id => 2)}
  let!(:order1) { Fabricate(:order, :id => 1, :status => "shipped", :customer_id => 1, :products => [product1, product2]) }
  let!(:order2) { Fabricate(:order, :id => 2, :status => "pending", :customer_id => 2) }
  let!(:order3) { Fabricate(:order, :id => 3, :status => "pending", :customer_id => 2) }
  let!(:order4) { Fabricate(:order, :id => 4, :status => "paid", :customer_id => 1) }
  let!(:order_item1) { Fabricate(:order_item, :order_id => 1, :product_id => 1, :quantity => 2, :price => 10) }
  let!(:order_item2) { Fabricate(:order_item, :order_id => 1, :product_id => 2, :quantity => 2, :price => 10) }
  let!(:orders) { [order1, order2, order3, order4] }

  before(:each) do
    Order.any_instance.stub(:decimal_total).and_return(1)
    OrderItem.any_instance.stub(:decimal_total).and_return(1)
    OrderItem.any_instance.stub(:decimal_price).and_return(1)
    order1.stub(:order_items).and_return([order_item1, order_item2])
    order1.stub(:products).and_return([product1, product2])
    OrdersController.stub(:verify_is_admin).and_return(true)
    visit orders_path
  end

  context "index" do
    it "lists all orders" do
      visit orders_path
      orders.each do |order|
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
        save_and_open_page
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