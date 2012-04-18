require 'spec_helper'

describe CartItem do
  let(:products) do 
    [].tap { |a| 5.times { a << Fabricate(:product) } }
  end
  let!(:order) { Fabricate(:order) }
  let(:cart_item) do
    Fabricate(:cart_item, product: products[0])
  end

  context "add_to_order" do
    it "adds_to_orders" do 
      cart_item.add_to_order(order)
        match_array = order.order_items.select do |order_item|
        order_item.order_id == order.id &&
        order_item.product_id == cart_item.product.id &&
        order_item.quantity == cart_item.quantity &&
        order_item.price == cart_item.product.price
      end
      match_array.size.should == 1
    end
  end
end
# == Schema Information
#
# Table name: cart_items
#
#  id         :integer         not null, primary key
#  cart_id    :integer
#  product_id :integer
#  quantity   :integer
#  price      :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

