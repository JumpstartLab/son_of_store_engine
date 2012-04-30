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
end


