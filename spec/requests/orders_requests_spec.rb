require 'spec_helper'

describe "Orders Requests" do
  let!(:order1) { Fabricate(:order, :status => "shipped") }
  let!(:order2) { Fabricate(:order, :status => "pending") }
  let!(:order3) { Fabricate(:order, :status => "pending") }
  let!(:orders) { [order1, order2, order3] }

  context "index" do
    it "lists all orders" do
      visit orders_path
      orders.each do |order|
        page.should have_link(order.id.to_s, :href => order_path(order))
      end
    end

    it "lists the number of orders for each status" do
      visit orders_path
      within("table#status_counts") do
        page.should have_content("Pending: 2")
      end
    end
  end
end