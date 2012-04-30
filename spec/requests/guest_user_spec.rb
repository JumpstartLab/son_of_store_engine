require 'spec_helper'

describe "Guest User" do
  let!(:store) do
    FactoryGirl.create(:store)
  end
  before(:each) do
    Capybara.app_host = "http://#{store.url}.son.test"
  end
  let!(:products) do
    (1..4).map { FactoryGirl.create(:product, :store => store)}
  end
  context "Generating a new guest order" do
    before(:each) do
      products.each do |p|
        # visit '/logout'
        # visit product_path(p)
        # click_on "Add To Cart"
        # save_and_open_page
        # click_link_or_button "Checkout"
        # click_link_or_button "Continue as Guest"
      end
    end

    it "adds billing and shipping info" do
      # page.should have_content "Credit Card Information"
    end

  end
end