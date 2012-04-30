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
      visit admin_stores_path
      page.should have_content "Not an admin"
    end
  end

  describe "GET /dashboard" do
    it "disallows unprivileged users" do
      login(user)
      visit admin_stores_path
      page.should have_content "Not an admin"
    end

    it "disallows a user with a manager privilege" do
      user.promote(order.store, :manager)
      login(user)
      visit admin_stores_path
      page.should have_content "Not an admin"
    end

    it "successfully logs in an admin" do
      login(admin)
      visit admin_stores_path
      page.should have_content "Administer"
    end
  end

  describe "while manager is logged in" do
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
      page.should have_content(order.current_status.titleize)
    end

    it "offers me the option to hire an employee" do
      page.should have_content("Add employee")
    end
  end

  context "When hiring an employee" do
    let!(:store) { FactoryGirl.create(:store) }
    before(:each) { login(admin) }
    before(:each) { visit store_dashboard_path(store) }
    it "adds the user as an employee if the user exists" do
      new_employee = FactoryGirl.create(:user)
      click_link "Add employee"
      fill_in "Email", with: new_employee.email
      select "stocker", from: "Role"
      click_button "Save changes"
      page.should have_content("hired")
      new_employee.may_stock?(store).should be_true
      ActionMailer::Base.deliveries.last.subject.include?("new job").should be_true
    end

    it "sends an invitation to the new employee if the account does not exist" do
      click_link "Add employee"
      fill_in "Email", with: "cheddar_bay@biscuits.com"
      select "stocker", from: "Role"
      click_button "Save changes"
      page.should have_content("invited")
      ActionMailer::Base.deliveries.last.subject.include?("sign up").should be_true
    end
  end
end
