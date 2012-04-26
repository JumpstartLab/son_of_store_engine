require 'spec_helper'

describe "Order New" do
  let!(:store) do
    FactoryGirl.create(:store)
  end
  before(:each) do
    Capybara.app_host = "http://#{store.url}.son.test"
  end
  let!(:user) do
    FactoryGirl.create(:user, :password => "mike", :stripe_id => "cus_WyPWX06WqQhlXo")
  end 
  let!(:products) do
    (1..4).map { FactoryGirl.create(:product, :store => store)}
  end
  context "Generating a new order" do
    before(:each) do
      login(user)
      products.each do |p|
        visit product_path(p)
        click_on "Add To Cart"
      end      
    end
    it "Address Updated with valid address" do
      visit new_order_path
      fill_in "order[user_attributes][street]", :with => "1375 Kenyon Street Nw"
      fill_in "order[user_attributes][zipcode]", :with => "20010"
      click_on "Pay"
      user.address.state.should == "District of Columbia"
    end
    it "Address failed with invalid address" do
      visit new_order_path
      Geocoder.stub(:search)
      fill_in "order[user_attributes][street]", :with => "sfsdfdsfsd"
      fill_in "order[user_attributes][zipcode]", :with => "32322343"
      click_on "Pay"
      #save_and_open_page
      page.should have_content("Address is invalid")
    end
  end
end