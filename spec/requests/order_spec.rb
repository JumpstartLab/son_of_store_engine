require 'spec_helper'

describe "Indivdiaul Order" do
  let!(:store) do
    FactoryGirl.create(:store)
  end
  before(:each) do
    Capybara.app_host = "http://#{store.url}.son.test"
  end  
  let!(:user) { FactoryGirl.create(:admin, :password => "mike") }
  let!(:non_admin_user) do
    FactoryGirl.create(:user, :password => "mike")
  end

  let!(:products) do
    [FactoryGirl.create(:product, :store => store), FactoryGirl.create(:product, :store => store)]
  end

  let!(:statuses) do
    [FactoryGirl.create(:status), 
     FactoryGirl.create(:status, :name => "paid"),
     FactoryGirl.create(:status, :name => "cancelled"),
     FactoryGirl.create(:status, :name => "returned"),
     FactoryGirl.create(:status, :name => "pending")]
  end

  let!(:orders) do
    [FactoryGirl.create(:order, :products => products, :status => statuses.last, :store => store), 
      FactoryGirl.create(:order, :products => products, :status => statuses[1], :store => store),
      FactoryGirl.create(:order, :user => user, :products => products, :status => statuses.first, :store => store)]
  end
  context "While not logged in" do
    it "Should be redirected if not logged in" do
      visit "/orders/new"
      page.should have_content "You must login first"
    end
    it 'rejects user if not their order' do
      login(non_admin_user)
      visit "/orders/#{orders.first.id}"
      page.should have_content('That is not your order')
    end
  end
  it 'navigates to the special url without auth' do
    visit "/orders/track?id=#{orders.first.unique_url}"
    page.should have_link(orders.first.unique_url)
  end
  it 'track fails with invalid url' do
    visit "/orders/track?id=mike-is-awesome"
    page.should have_content "Invalid Order tracking code"
  end  
  context "Order Edit Page" do 
    before(:each) do
      login(user)
      visit edit_admin_order_path(orders.first)
    end
    it "Can update an order" do
      click_on "Save Order"
      page.should have_content "Order has been updated"
    end
  end
  context "Search through my products" do
    it "searches for a product in my orders" do
      login(user)
      visit '/orders/my_orders'
      fill_in "mq", :with => products.first.name
      click_on "Search"
      page.should have_content products.first.name
    end
  end
  context "order show page" do
    before(:each) do
      login(user)
      visit "/orders/#{orders.first.id}"
    end
    it 'my orders' do
      visit my_orders_orders_path
      page.should have_content(orders.last.total_price)
    end
    it "displays when returned timestamp" do
      visit "/orders/#{orders[1].id}"
      click_on '[mark as shipped]'
      page.should have_content('Shipped At')
    end

    it "displays if cancelled timestamp" do
      click_on '[cancel]'
      page.should have_content('Cancelled At')
    end
  end
end