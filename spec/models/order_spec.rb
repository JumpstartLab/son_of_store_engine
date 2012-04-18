require 'spec_helper'
describe Order do
  let!(:user){ Fabricate(:user) }
  let!(:customer){ Fabricate(:customer, user_id: user.id) }
  let!(:order) { Fabricate(:order, :status => "pending", :id => 1, :customer_id => customer.id) }
  let!(:order_item1) { Fabricate(:order_item, :price => 10, :quantity => 2, :order_id => 1, :product_id => 1) }
  let!(:order_item2) { Fabricate(:order_item, :price => 20, :quantity => 1, :order_id => 1, :product_id => 2) }
  let!(:products) {[Fabricate(:product, id: 1), Fabricate(:product, id: 2)]}
  let!(:cart){ Fabricate(:cart) }


  before(:each) do
    order.stub(:order_items).and_return([order_item1, order_item2])
    products.each { |product| cart.add_product(product) }
  end

  describe '#update_attributes' do
    it "shouldn't default to cancelled" do
      order.should_not be_cancelled
    end
    it "should update all attributes as normal" do
      order.update_attributes(:customer_id => 20)
      order.customer_id.should == 20
    end
    context "status is changed to shipped" do
      it "records the timestamp that the order was marked shipped" do
        order.update_attributes(:status => "shipped")
        order.shipped.to_date.should == Date.today
      end
    end
    context "status is changed to returned" do
      it "records the timestamp that the order was marked returned" do
        order.update_attributes(:status => "cancelled")
        order.cancelled.to_date.should == Date.today
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
      o = Order.create
      o.add_from_cart(cart)
      products.each do |p|
        o.products.should be_include(p)
      end
    end
  end

  describe "search, create" do
    it "finds the correct order" do
      o = Order.search(products.first.title, user)
      o.first.products.should be_include(products[0])
    end
  end

  describe "find an order by product" do
    it "fails to find gibberish" do
      Order.search("lkasdfkdfsak", user).any?.should == true
    end

    it "returns correct search result" do

    end
  end
end
# == Schema Information
#
# Table name: orders
#
#  id          :integer         not null, primary key
#  status      :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  shipped     :date
#  cancelled   :date
#  customer_id :integer
#

