require 'spec_helper'

describe "Orders Requests" do
  context "show" do
    let!(:store) { Fabricate(:store) }
    let(:order) do
      o = Fabricate(:order, :store => store)
      o.products << Fabricate(:product, :store => store)
      o.products << Fabricate(:product, :store => store)
      o.products << Fabricate(:product, :store => store)
      double_product = Fabricate(:product, :store => store)
      o.products << double_product
      o.products << double_product
      o
    end

    it "has product titles for an order" do
      visit order_path(store, order)
      order.products.each do |product|
        page.should have_content product.title
      end
    end

    it "has product subtotals for an order" do
      visit order_path(store, order)
      order.products.each do |product|
        page.should have_content order.subtotal(product)
      end
    end

    it "has a price for each product in an order" do
      visit order_path(store, order)
      order.products.each do |product|
        page.should have_content product.price
      end
    end
  end
end
