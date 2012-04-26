require 'spec_helper'

describe "Guest User" do
  let!(:store) do
    FactoryGirl.create(:store)
  end
  before(:each) do
    Capybara.app_host = "http://#{store.id}.son.test"
  end
  let!(:products) do
    (1..4).map { FactoryGirl.create(:product, :store => store)}
  end
  context "Generating a new guest order" do
    before(:each) do
      products.each do |p|
        visit product_path(p)
        click_on "Add To Cart"
      end
      click_link_or_button "Checkout"
      click_link_or_button "Continue as Guest"
    end

    it "adds billing and shipping info" do
      Geocoder.stub(:search)
      fill_in "card_number", :with => "4242424242424242"
      fill_in "card_code", :with => "123"
      select('2014', :from => 'card_year')
      fill_in "order[user_attributes][street]", :with => "1375 Kenyon Street Nw"
      fill_in "order[user_attributes][zipcode]", :with => "20010"
      fill_in "order[user_attributes][email]", :with => "test@test.com"
      # click_on "Pay"

      # page.should have_content "Order details"
      pending
    end

  end
end