require 'spec_helper'

describe "Creating Shipping Detail" do
  before(:each) do
    set_host("best-sunglasses")
    visit "/shipping_details/new"
  end

  it "should show the new shipping details page" do
    page.should have_content "Add a Shipping Address"
  end

  context "when logged in" do
    let!(:user) { FactoryGirl.create(:user) }
    before(:each) do
      visit "/sessions/new"
      fill_in "email", with: user.email
      fill_in "password", with: "foobar"
      click_link_or_button('Log in')
    end

    context "when information is entered" do

      before(:each) do
        visit "/shipping_details/new"
        fill_in "shipping_detail_ship_to_name", with: "Ed"
        fill_in  "shipping_detail_ship_to_address_1", with: "1445 NH Ave"
        fill_in "shipping_detail_ship_to_city", with: "Washington"
        fill_in "shipping_detail_ship_to_zip", with: "20036"
        click_link_or_button('Create Shipping detail')
      end

      it "Should take me to a different page" do
        uri = URI.parse(current_url)
        "#{uri.path}".should_not == new_shipping_detail_url
      end
    end
  end
end
