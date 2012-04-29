require 'spec_helper'

describe "As an admin visiting the dashboard" do
  let!(:store) { Store.first }
  let!(:user) { FactoryGirl.create(:user, :admin => true) }
  context "and I'm not logged in" do
    before(:each) { visit admin_dashboard_path(store) }
    it "redirects me to the signin page" do
      page.should have_content("Sign in")
    end
  end

  context "and I'm logged in" do
    let(:order_product) { FactoryGirl.create(:order_product) }
    let!(:pending_order) { FactoryGirl.create(:order, 
      :user => user, :order_products => [order_product]) }
    before(:each) do
      set_host("woraces-workshop")
      visit "/sessions/new"
      fill_in "email", with: user.email
      fill_in "password", with: "foobar"
      click_link_or_button('Log in')
      visit admin_dashboard_path(store)
    end


    it "lets me view the dashboard" do
      page.should have_content("Admin Dashboard")
    end

  end

end
