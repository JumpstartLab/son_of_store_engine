require 'spec_helper'

describe "Orders Requests" do
  let!(:product1) { Fabricate(:product) }
  let!(:product2) { Fabricate(:product) }
  let!(:user1) { Fabricate(:user, :id => 1, :email => "ham@gmail.com", :name => "Fred Banks") }
  let!(:user2) { Fabricate(:user, :id => 2)}
  let!(:order1) { Fabricate(:order, :status => "shipped", :user_id => 1, :products => [product1, product2]) }
  let!(:order2) { Fabricate(:order, :status => "pending", :user_id => 2) }
  let!(:order3) { Fabricate(:order, :status => "pending", :user_id => 2) }
  let!(:order4) { Fabricate(:order, :status => "paid", :user_id => 1) }
  let!(:orders) { [order1, order2, order3, order4] }

  before(:each) do
    visit orders_path
  end

  context "index" do
    it "lists all orders" do
      orders.each do |order|
        page.should have_content(order.user.name)
      end
    end

    it "lists the number of orders for each status" do
      within("div#filters") do
        page.should have_content("Pending: 2")
      end
    end

    it "lists each product ordered for each order" do
      #within("div#order_1_detail") do
        page.should have_content(product1.title)
        page.should have_content(product2.title)
      #end
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