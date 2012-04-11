require 'spec_helper'

describe Order do
  let(:order) { Fabricate(:order, :status => "pending") }
  let(:order_item1) { Fabricate(:order_item, :price => 10, :quantity => 2) }
  let(:order_item2) { Fabricate(:order_item, :price => 20, :quantity => 1) }
  let(:products) {[Fabricate(:product, id: 1), Fabricate(:product, id: 2)]}
  let(:cart){ Fabricate(:cart) }


  before(:each) do
    order.stub(:order_items).and_return([order_item1, order_item2])
    products.each { |product| cart.add_product(product) }
  end

  describe '#update_attributes' do
    it "should update all attributes as normal" do
      order.update_attributes(:user_id => 20)
      order.user_id.should == 20
    end
    context "status is changed to shipped" do
      it "records the timestamp that the order was marked shipped" do
        order.update_attributes(:status => "shipped")
        order.shipped.to_date.should == Date.today
      end
    end
    context "status is changed to returned" do
      it "records the timestamp that the order was marked returned" do
        order.update_attributes(:status => "returned")
        order.returned.to_date.should == Date.today
      end
    end
  end
  describe '#total' do
    it "should return the total cost of the order" do
      order.total.should == 40
    end
  end
  describe '#decimal_total' do
    it "should return a money object of the total/100" do
      order.stub(:total).and_return(123)
      order.decimal_total.should == Money.new(123)
    end
  end

  describe "create_from_cart" do
    it "creates an order. FROM THE CART" do
      o = Order.create_from_cart(cart)
      products.each do |p|
        o.products.should be_include(p)
      end
    end
  end
end
# == Schema Information
#
# Table name: orders
#
#  id         :integer         not null, primary key
#  status     :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

