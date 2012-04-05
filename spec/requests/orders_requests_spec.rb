require 'spec_helper'

describe "Orders Requests" do
  let!(:order1) { Fabricate(:order, :status => "shipped") }
  let!(:order2) { Fabricate(:order, :status => "pending") }
  let!(:order3) { Fabricate(:order, :status => "pending") }
  let!(:order4) { Fabricate(:order, :status => "paid") }
  let!(:orders) { [order1, order2, order3, order4] }

  before(:each) do
    visit orders_path
  end

  context "index" do
    it "lists all orders" do
      orders.each do |order|
        page.should have_link(order.id.to_s, :href => order_path(order))
      end
    end

    it "lists the number of orders for each status" do
      within("table#status_counts") do
        page.should have_content("Pending: 2")
      end
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
          page.should have_content("canceled")
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
          page.should have_content("returned")
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
          page.should have_content("shipped")
        end
      end
    end
  end

  context "filtered index" do
    it "lists orders only for that category" do
      within("ul#filters") do
        click_link("Pending")        
      end
      page.should have_link(order2.id.to_s, :href => order_path(order2))
      page.should_not have_link(order1.id.to_s, :href => order_path(order1))
    end
  end
end