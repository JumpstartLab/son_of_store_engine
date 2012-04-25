require 'spec_helper'

describe "super admin" do
  let!(:store1) { Fabricate(:store, approval_status: "pending") }
  let!(:store2) { Fabricate(:store, approval_status: "approved", enabled: true) }
  let!(:store3) { Fabricate(:store, approval_status: "approved", enabled: false) }

  context "stores dashboard" do
    before(:each) do
      visit admin_stores_path
    end

    it "shows a list of all the stores" do
      Store.all.each do |store|
        page.should have_content store.name
        page.should have_content store.domain
        page.should have_content store.approval_status
        page.should have_content store.active_status
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
        it "has links to enable or disable the store" do
          within "##{dom_id(store2)}" do
            page.should_not have_link "Enable"
            page.should have_link "Disable"
          end
        end
      end
      context "the store is disabled" do
        it "has links to enable or disable the store" do
          within "##{dom_id(store3)}" do
            page.should have_link "Enable"
            page.should_not have_link "Disable"
          end
        end
      end
    end
  end
end