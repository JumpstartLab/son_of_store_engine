require 'spec_helper'

describe "Dashboard" do
    let(:user) { FactoryGirl.create(:user) }
    let(:admin) { FactoryGirl.create(:user, :admin => true) }
    let(:test_user) { FactoryGirl.create(:user) }
    let(:test_products) do
      (1..5).map { FactoryGirl.create(:product) }
    end

    let(:order_item_1) { FactoryGirl.create(:order_item, :unit_price => 100, :quantity => 2) }
    let(:order_item_2) { FactoryGirl.create(:order_item, :unit_price => 200, :quantity => 2) }
    let(:oo) { [order_item_1, order_item_2] }
    let!(:order) { FactoryGirl.build(:order_with_items) }

    let(:user) { FactoryGirl.create(:user, :full_name => "Darth") }
    let!(:evil_order) { FactoryGirl.create(:order, :user => user) }
  
  describe "admin access" do
    it "requires admin login" do
      visit dashboards_path
      page.should have_content "Not an admin"
    end
  end

  describe "GET /dashboard" do
    it "requires admin for logged in users" do
      login(user)
      visit dashboards_path
      page.should have_content "Not an admin"
    end

    it "successfully logs in an admin" do
      login(admin)
      visit dashboards_path
      page.should have_content "Dashboard"
    end
  end

  describe "while admin is logged in" do
    let!(:store) { FactoryGirl.create(:store) }
    before(:each) { login(admin) }
    before(:each) { order.update_attribute(:store_id, store.id)}
    before(:each) { visit store_dashboard_path(store) }

    it "displays the list of all orders" do
      find('#order_count').should have_content(store.orders.count)
    end

    it "displays the user name for each order" do
      page.should have_content(order.user.full_name)
    end

    it "displays the total price for each order" do
      page.should have_content(order.total_price)
    end

    it "displays the order status for each order" do
      page.should have_content(order.current_status)
    end
  end
end