require 'spec_helper'
require 'Capybara'

describe "Signle Sign in" do
  let!(:user) { FactoryGirl.create(:admin, :password => "mike")}
  let!(:store) { FactoryGirl.create(:store) }
  let!(:store2) { FactoryGirl.create(:store) }
  let(:product) { FactoryGirl.create(:product, :store => store)}
  context "Logging in once should stay logged in across all domains" do
    before(:each) do
      Capybara.app_host = "http://#{store.url}.son.test"
      login(user)
    end
    it "is logged in to a store" do
      Capybara.app_host = "http://#{store2.url}.son.test"
      visit login_path
      page.should have_content "Must not be logged in"
    end
    context "Cart is different across domains" do
      before(:each) do
        visit product_path(product)
      end
      it "adds product to cart" do
        click_on "Add To Cart"
        Capybara.app_host = "http://#{store2.url}.son.test"
        visit cart_path
        page.should_not have_content product.name
      end
    end
  end
end