require 'spec_helper'

describe "Orders Requests" do
  let!(:order1) { Fabricate(:order) }
  let!(:order2) { Fabricate(:order) }
  let!(:orders) { [order1, order2] }

  context "index" do
    it "lists all orders" do
      visit orders_path
      orders.each do |order|
        page.should have_link(order.id.to_s, :href => order_path(order))
      end
    end
  end
end