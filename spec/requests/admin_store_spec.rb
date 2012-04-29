require 'spec_helper'

describe "the admin stores page", :requests => :admin_store do
  let(:admin) { FactoryGirl.create(:user, :admin => true) }
  let!(:store) { FactoryGirl.create(:store) }
  context "on the admin/stores page" do
    before(:each) do
      login(admin)
    end

    it "shows me all the stores in the system" do
      visit admin_stores_path
      page.should have_content store.name
      page.should have_content store.slug
      page.should have_content store.status
    end

    context "admin manipulating store status" do
      it "allows admin to accept a store request" do
        visit admin_stores_path
        click_link "Approve"
        store.reload
        store.status.should == "enabled"
        page.should_not have_link "Approve"
      end

      it "allows admin to decline a store request" do
        visit admin_stores_path
        click_link "Decline"
        Store.count.should == 0
        page.should_not have_link "Approve"
      end

      it "allows admin to enable a disabled store" do
        store.disable!
        visit admin_stores_path
        click_link "Enable"
        store.reload
        store.status.should == "enabled"
        page.should_not have_link "Approve"
        page.should_not have_link "Enable"
      end

      it "allows admin to disable an enabled store" do
        store.enable!
        visit admin_stores_path
        click_link "Disable"
        store.reload
        store.status.should == "disabled"
        page.should_not have_link "Decline"
        page.should_not have_link "Disable"
      end

      it "allows admin to edit store" do
        visit admin_stores_path
        click_link "Edit"
        page.current_path.should == edit_store_path(store)
      end
    end
  end  
end
