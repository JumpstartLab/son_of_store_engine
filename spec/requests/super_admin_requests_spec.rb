require 'spec_helper'

describe "super admin" do
  let!(:store1) { Fabricate(:store, approval_status: "pending") }
  let!(:store2) { Fabricate(:store, approval_status: "approved", enabled: true) }
  let!(:store3) { Fabricate(:store, approval_status: "approved", enabled: false) }
  let!(:store4) { Fabricate(:store, approval_status: "pending") }
  let!(:user) { Fabricate(:user, admin: true) }

  context "stores dashboard" do
    before(:each) do
      visit root_path
      click_link_or_button "Sign-In"
      login(email: user.email_address, password: user.password)
      visit admin_stores_path
    end

    it "shows a list of all the stores" do
      Store.all.each do |store|
        page.should have_content store.name
        page.should have_content store.domain
        page.should have_content store.approval_status
        within "#store_#{store.id}" do
          enable_state = store.enabled ? "Yes" : "No"
          find(".enabled").text.should have_content enable_state
        end
      end
    end

    it "shows the first 32 characters of each store description" do
      Store.all.each do |store|
        page.should have_content store.description[0..31]
      end
    end

    context "a store is pending approval" do
      it "does not have links to enable or disable the store" do
        within "##{dom_id(store1)}" do
          page.should_not have_link "Enable"
          page.should_not have_link "Disable"
        end
      end

      it "has links to approve or decline the store" do
        within "##{dom_id(store1)}" do
          page.should have_link "Approve"
          page.should have_link "Decline"
        end
      end
    end

    context "a store is not pending approval" do
      it "does not have links to approve or decline the store" do
        within "##{dom_id(store2)}" do
          page.should_not have_link "Approve"
          page.should_not have_link "Decline"
        end
      end
      context "the store is enabled" do
        it "has a link to disable the store" do
          within "##{dom_id(store2)}" do
            page.should_not have_link "Enable"
            page.should have_link "Disable"
          end
        end
      end
      context "the store is disabled" do
        it "has a link to enable the store" do
          within "##{dom_id(store3)}" do
            page.should have_link "Enable"
            page.should_not have_link "Disable"
          end
        end
      end
    end
    
    context "approving a new store" do
      before(:each) do
        within "#store_#{store1.id}" do
          click_link "Approve"
        end
      end
      context "clicking the 'Approve' link" do
        it "sets the store approval status to approved" do
          find("#store_approval_status").text.downcase.should have_content "approved"
        end
        it "returns the admin to the dashboard with a flash approval message" do
          current_path.should == admin_store_path(store1)
          page.should have_content "has been approved."
        end
      end
    end
    
    context "declining a new store" do
      before(:each) do
        within "##{dom_id(store1)}" do
          click_link "Decline"
        end
      end
      context "clicking the 'Decline' link" do
        it "sets the store approval status to declined" do
          find("#store_approval_status").text.downcase.should have_content "declined"
        end
        it "returns the admin to the dashboard with a flash decline message" do
          current_path.should == admin_store_path(store1)
          page.should have_content "has been declined."
        end
      end
    end
  end
  
  context "when attempting to access as a regular user" do
    let!(:regular_user)   { Fabricate(:user) }
    
    before(:each) do
      visit root_path
      click_link_or_button "Sign-In"
      login(email: regular_user.email_address, password: regular_user.password)
      visit admin_stores_path
    end
    
    it "does not allow access" do
      current_path.should_not == admin_stores_path
    end
    
    it "returns an error" do
      page.should have_content "Unauthorized Access"
    end
  end
end
