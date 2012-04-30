require 'spec_helper'

describe Order do
  let(:test_user) { FactoryGirl.create(:user) }
  let(:address) { FactoryGirl.create(:address) }
  let(:test_user) { FactoryGirl.create(:user, :addresses => [address]) }
  let(:test_products) do
    (1..5).map { FactoryGirl.create(:product) }
  end

  let(:order_item_1) { FactoryGirl.create(:order_item, :unit_price => 100, :quantity => 2) }
  let(:order_item_2) { FactoryGirl.create(:order_item, :unit_price => 200, :quantity => 2) }
  let(:oo) { [order_item_1, order_item_2] }
  let(:order) { FactoryGirl.create(:order, :order_items => oo, :user => test_user) }
  
  before(:each) do
    @attr = {
      user: test_user,
      products: test_products
    }
  end
  
  it "should create an order given valid attributes" do
    Order.create(@attr)
  end

  it "should have a status" do
    order.current_status.should_not == nil
  end

  it "should have a default status of 'pending'" do
    order.current_status.should == "pending"
  end

  describe "#total_price" do
    it "gets the correct total price of the order" do
      order.total_price.should == BigDecimal.new("600")
    end

    it "returns a BigDecimal" do
      order.total_price.should be_a BigDecimal
    end
  end

  describe "#total_price_in_cents" do
    it "returns a BigDecimal" do
      order.total_price.should be_a BigDecimal
    end

    it "gets the correct total price of the order in cents" do
      order.total_price_in_cents.should == BigDecimal.new("60000")
    end
  end

  describe "#add_order_items_from" do
    let (:cart)     { Cart.create }
    let (:products) { [product_1, product_2] }
    let (:new_order) { FactoryGirl.create(:order) }

    before(:each) { test_products.each { |p| cart.add_product(p) } }
    it "matches the cart_items to order_items" do
      new_order.add_order_items_from(cart)
      new_order.total_price.should == cart.total_price
    end
  end

  describe "#create_stripe_user" do
    it "saves the token to the user" do
      customer = Stripe::Customer.create(
        :description => "Customer for christopher.anderson@gmail.com",
        :card => {
        :number => "4242424242424242",
        :exp_month => 4,
        :exp_year => 2013,
        :cvc => 314
      },)
      Stripe::Customer.stub!(:create).and_return(customer) 
      order.create_stripe_user(valid_card_data)
      test_user.stripe_id = customer.id
      test_user.stripe_id.should == customer.id
    end
  end

  describe "#two_click", :order => :two_click do
    let (:order) { FactoryGirl.create(:order) }
    let (:product) { double("product", id: 100, price: "10000") }
    let (:order_address) { FactoryGirl.create(:address) }
    let (:two_click_user) { double("user", addresses: [order_address])}

    before(:each) do
      Product.stub(:find).with(100).and_return(product)
    end

    it "creates an order with one item" do
      order.two_click(product.id)
      order.order_items.length.should == 1
    end

    it "creates an order item with price 10000" do
      order.two_click(product.id)
      order.order_items.first.unit_price.should == BigDecimal.new("10000")
    end

    it "saves current user's address" do
      order.should_receive(:user).and_return(two_click_user)
      order.two_click(product.id)
      order.address.should == order_address
    end
  end

  describe "#generate_unique_url", :model => :unique_url do
    it "generates a url upon order creation" do
      order = FactoryGirl.create(:order)
      Order.last.unique_url.should_not == nil
    end
  end

  describe "after order creation" do
    it "calls BackgroundJob.order_email" do
      order = Order.new
      user = double("user")
      order.stub(:order_user).and_return(user)
      BackgroundJob.should_receive(:order_email).with(user, order)
      order.save
    end
  end

  describe "after status update", :model => :bj  do
    it "calls BackgroundJob.order_email" do
      order = FactoryGirl.create(:order)
      user = double("user", :id => 1)
      order.stub(:order_user).and_return(user)
      BackgroundJob.should_receive(:order_status_email).with(user, order)
      order.update_status("paid")
    end
  end
end
