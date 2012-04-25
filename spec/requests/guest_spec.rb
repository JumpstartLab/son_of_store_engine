require "spec_helper"
describe "given a user with an email address" do
  let(:params){ {user: {email: "HAROLD@vom.com"}}  }
  let(:user){ User.find_by_email("HAROLD@vom.com") }
  describe "new_guest" do
    before(:each) do
      visit new_guest_path
      page.fill_in("user_email", with: "HAROLD@vom.com")
      click_link_or_button("Continue as guest")
    end
    it "saves the user to the db" do
      user.should_not be_nil
    end

    it "saves shipping information" do
      visit guest_shipping_path(user_id: user.id)
      fill_in "shipping_detail_ship_to_name", with: "Ed"
      fill_in "shipping_detail_ship_to_address_1", with: "1445 NH Ave"
      fill_in "shipping_detail_ship_to_city", with: "Washington"
      fill_in "shipping_detail_ship_to_zip", with: "20036"
      click_link_or_button('Create Shipping detail')
      user.shipping_details.should_not be_empty
    end
  end
end