require 'spec_helper'

describe "Users Requests" do
  let!(:user) { Fabricate(:user) }
  let!(:order1) { Fabricate(:order) }
  let!(:order2) { Fabricate(:order) }
  let!(:order_item1) { Fabricate(:order_item) }
  let!(:order_item2) { Fabricate(:order_item) }
  let!(:product1) { Fabricate(:product) }
  let!(:product2) { Fabricate(:product) } 

  before(:each) do
    user.stub(:orders).and_return([order1, order2])
    order1.stub(:order_items).and_return([order_item1, order_item2])
    order1.stub(:user).and_return(user)
    order2.stub(:user).and_return(user)
    order_item1.stub(:product).and_return(product1)
    order_item2.stub(:product).and_return(product2)
    UsersController.any_instance.stub(:current_user).and_return(user)
    visit user_path(user)
  end

  describe 'show' do
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
      it "logs the user in" do
        click_button(:submit)
        puts UsersController..send(:current_user)
      end
    end
    context "when invalid parameters are passed" do
    end
  end
end