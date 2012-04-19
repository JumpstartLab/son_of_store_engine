require 'spec_helper'

describe "searching for a product" do
  let!(:product) { Fabricate(:product, id: 1)}
  let!(:products) { 10.times { Fabricate(:product) } }
  let!(:user) { Fabricate(:auth_user, id: 1) }
  let!(:order) { Fabricate(:order, :id => 1, :customer_id => customer.id, :status => "pending") }
  let!(:order_item){ Fabricate(:order_item, product_id: product.id, order_id: 1)}
  let!(:customer) { Fabricate(:customer, :user_id => 1) }
  it "searches for the product" do
    encoded = URI.encode(product.title)
    visit "/search?search%5Bproducts%5D=#{encoded}&commit=Search+for+Products"
    page.should have_content(product.title)
  end

  context "admin search" do 
    let(:search) { Search.new }
    before(:each) do
      login_user_post("whatever@whatever.com", "admin")
    end

    it "finds an order by product title" do
      params = { title: product.title }
      results = search.find(params)
      results.each do |ord|
        ord.products.each {|p| p.title.should == product.title }
      end
    end

    it "finds orders by order status" do
      params = { status: order.status }
      results = search.find(params)
      results.each do |ord|
        ord.status.should == order.status
      end
    end

    describe "finds orders by date" do
      it "finds dates that are equal" do 
        params = { date: order.created_at , d_sym: "=" }
        results = search.find(params)
        results.each do |ord|
          ord.created_at.should == (order.created_at)
        end
      end


      it "finds orders greater than date" do
        params = { date: (order.created_at - 1) , d_sym: ">" }
        results = search.find(params)
        results.each do |ord|
          ord.created_at.should > (order.created_at - 1)
        end
      end

      it "finds orders greater than date" do
        params = { date: (order.created_at - 1) , d_sym: "<" }
        results = search.find(params)
        results.each do |ord|
          ord.created_at.should < (order.created_at - 1)
        end
      end
    end
    describe "finding orders by total" do
      it "finds orders less than total" do
        params = { total: (order.total + 100) , t_sym: "=" }
        results = search.find(params)
        results.each do |ord|
          ord.total.should == (order.total + 100)
        end
      end

      it "finds orders less than total" do
        params = { total: order.total , t_sym: "<" }
        results = search.find(params)
        results.each do |ord|
          ord.total.should < order.total
        end
      end
      it "finds orders less than total" do
        params = { total: (order.total + 100) , t_sym: ">" }
        results = search.find(params)
        results.each do |ord|
          ord.total.should > (order.total + 100)
        end
      end
    end
    describe "finding orders by user email" do 
      it "finds orders less than total" do
        params = { email: order.user.email }
        results = search.find(params)
        results.each do |ord|
          ord.user.email.should == order.user.email
        end
      end
    end

  end
end
