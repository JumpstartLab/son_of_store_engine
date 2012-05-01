require 'spec_helper'

describe "Store Admin Permissions" do
  let!(:store_owner) { Fabricate(:user) }
  let!(:other_user) { Fabricate(:user) }
  let!(:store) { Fabricate(:store, creating_user_id: store_owner.id) }

  describe "accessing store admin dashboard" do
    context "the user is the store owner" do
      before(:each) do
        visit root_path
        click_link_or_button "Sign-In"
        login(email: store_owner.email_address, password: store_owner.password)
      end
      it "allows the user to access the page" do
        visit "/#{store.to_param}/admin"
        current_path.should == "/#{store.to_param}/admin"
        page.should have_content "Store Settings"
      end
    end
    context "the user is not a store admin" do
      before(:each) do
        visit root_path
        click_link_or_button "Sign-In"
        login(email: other_user.email_address, password: other_user.password)
      end
      it "doesn't allow the user to access the page" do
        visit "/#{store.to_param}/admin"
        current_path.should == root_path
        page.should_not have_content "Store Settings"
      end
    end
  end

  describe "signing up after recieving an admin invite" do
    let!(:store) { Fabricate(:store) }
    let!(:store_permission) { Fabricate(:store_permission, user_id: nil, admin_hex: "12345", store_id: store.id)}
    before(:each) do
      visit '/users/new?invite_code=12345'
      sign_up({full_name: "Test User", email: "frank@zappa.com", password: "test", display_name: "Test"})
    end

    it "creates a new user" do
      User.last.display_name.should == "Test"
    end

    it "assigns the user's id to the store_permission record" do
      StorePermission.last.user_id.should == User.last.id
    end
  end
end


