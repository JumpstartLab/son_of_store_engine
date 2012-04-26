require 'spec_helper'

describe "As an admin visiting the dashboard" do
  let!(:store) { FactoryGirl.create(:store,
                                   :name => "Test Store",
                                   :url_name => "test-store",
                                   :description => "errday im testin",
                                   :approved => true,
                                   :enabled => true) }
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
      login_user_post(user.email, "foobar")
      visit admin_dashboard_path(store)
    end

    it "lets me view the dashboard" do
      page.should have_content("Admin Dashboard")
    end

  end

end
