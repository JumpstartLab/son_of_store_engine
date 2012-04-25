require 'spec_helper'

describe "unique_orders" do
  let!(:test_user) { FactoryGirl.create(:user) }
  let!(:address) { FactoryGirl.create(:address)}
  let!(:order) { FactoryGirl.create(:order, :unique_url => "omg", :user => test_user, :address => address) }
  

  context "when visiting unique url of order", :requests => :url_show do
    it "displays the order" do
      # raise Order.last.inspect
      # raise order.unique_url.inspect
      visit unique_order_path("omg")
      page.should have_content(order.id)
    end
  end
end