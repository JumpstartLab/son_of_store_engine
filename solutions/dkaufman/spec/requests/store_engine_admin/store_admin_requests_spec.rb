require 'spec_helper'

describe "Store Admin Requests" do
  let!(:admin_user) { Fabricate(:user, admin: true) }
  let!(:store_owner) { Fabricate(:user) }
  let!(:store) { Fabricate(:store, creating_user_id: store_owner.id)}
  before(:each) do
    visit root_path
    click_link_or_button "Sign-In"
    login(email: admin_user.email_address, password: admin_user.password)
  end
  context "when on the admin stores index page" do
    before(:each) do
      visit "/admin/stores"
    end
    it "should have an administer button" do
      page.should have_content "Administer"
    end
    it "can do see the store admin page" do
      click_link_or_button "Administer"
      current_path.should == "/#{store.to_param}/admin"
    end
    it "can edit the store name" do
      click_link_or_button "Administer"
      old_name = store.name
      click_link_or_button "Edit"
      fill_in :name, with: "Other store name"
      click_link_or_button "Update Store"
      page.should have_content "Other store name"
      page.should_not have_content old_name
    end
    context "when disabling a store" do
      it "notifies about the store being disabled" do
        click_link_or_button "Disable"
        current_path.should == "/admin/stores/#{store.to_param}"
        page.should have_content "has been disabled"
        page.should have_content "Enable"
      end
      context "when navigating to the store" do
        it "says that the store is under maintenance" do
          click_link_or_button "Disable"
          visit "/#{store.to_param}"
          page.should have_content "maintenance"
          page.should_not have_content "$"
        end
      end
    end
  end
end
