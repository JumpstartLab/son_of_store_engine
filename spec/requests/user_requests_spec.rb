require 'spec_helper'

describe "User Requests" do
  let!(:user) { Fabricate(:user, :id => 1) }
  let!(:customer) { Fabricate(:customer, :user_id => 1, :id => 1)}
  let!(:order1) { Fabricate(:order, :id => 1, :customer_id => 1) }
  let!(:order2) { Fabricate(:order, :id => 2, :customer_id => 1) }
  let!(:order_item1) { Fabricate(:order_item, :order_id => 1, :product_id => 1) }
  let!(:order_item2) { Fabricate(:order_item, :order_id => 2, :product_id => 2) }
  let!(:product1) { Fabricate(:product, :id => 1) }
  let!(:product2) { Fabricate(:product, :id => 2) }

  before(:each) do
      visit login_path
      fill_in 'Email', :with => user.email
      fill_in 'Password', :with => user.password
      click_button 'Log in'

      UsersController.any_instance.stub(:current_user).and_return(user)
      user.stub(:customer).and_return(customer)
      customer.stub(:orders).and_return([order1, order2])
  end

  describe 'show' do
    before(:each) do
      visit user_path(user)
    end
    it "shows each order the user has made" do
      page.should have_content(order1.status)
      page.should have_content(order2.status)
    end
    it "shows each product the user has ordered" do
      page.should have_content(product1.title)
      page.should have_content(product2.title)
    end
  end

  describe 'new' do
    it 'shows the new user form' do
      visit new_user_path
      page.should have_selector('input#user_name')
      page.should have_selector('input#user_display_name')
      page.should have_selector('input#user_email')
      page.should have_selector('input#user_password')
    end
  end

  describe 'create' do
    context "when valid parameters are passed" do
      before(:each) do
        visit new_user_path
        fill_in('Name', :with => 'Frank Zappa')
        fill_in('Email', :with => 'polka@allday.com')
        fill_in('Password', :with => 'password')
      end
      it "creates a new user" do
        user_count = User.all.count
        click_button(:submit)
        User.all.count.should == user_count + 1
      end
      it "takes the user to the products index" do
        click_button(:submit)
        page.should have_content(product1.title)
        page.should have_content(product2.title)
      end
    end
    context "when invalid parameters are passed" do
      it "renders the create page" do
        visit new_user_path
        fill_in('Name', :with => 'Frank Zappa')
        fill_in('Email', :with => '')
        fill_in('Password', :with => 'password')
        click_button(:submit)
        page.should have_content('Name')
        page.should have_content('Email')
        page.should have_content('Password')
      end
    end
  end
end