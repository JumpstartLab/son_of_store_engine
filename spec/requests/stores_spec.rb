require 'spec_helper'

describe "Stores" do
  before(:each) do
    Capybara.app_host = "http://.son.test"
  end  
  let!(:user) do 
    FactoryGirl.create(:user, :password => "mike")
  end
  let!(:admin) do 
    FactoryGirl.create(:admin, :password => "mike")
  end  
  describe "User Owns Store" do
    context "Create Store as user" do
      before(:each) do
        login(user)
      end
      it "creates a new store" do
        visit new_admin_store_path
        fill_in 'store[name]', :with => "my test store"
        fill_in 'store[description]', :with => "My AWESOME store"
        fill_in 'store[description]', :with => "My AWESOME store"
        fill_in 'store[url]', :with => 'my-test-store'
        click_on 'Create Store'
        page.should have_content "Store was successfully created."
      end
      it "Store created should not be live" do
        visit "http://my-test-store.son.test"
        page.should have_content "page you were looking"
      end
      context "approve store as admin" do
        before(:each) do
          login(admin)
          visit admin_stores_path
        end
        context "Enabling" do
          it "should be able to approve a store" do
            click_on "Approve"
            page.should have_content "#{store.name} Successfully Approved"
          end
          it "and then enable a store" do      
             click_on "Enable"
             page.should have_content "#{store.name} Successfully Enabled"
          end
          it "should now be able to see the store" do
            visit "http://my-test-store.son.test"
            page.should have_content "Products" 
          end
        end
        context "Disabling" do
          it "disables a store" do
            click_on "Disable"
            page.should have_content "Successfully Disabled"
          end
          it "and then the store is no longer showed" do
            visit "http://my-test-store.son.test"
            page.should have_content "page you were looking"            
          end
        end
        context "Disapprove a store" do
          let!(:store2) { FactoryGirl.create(:store, :active => 1, :enabled => false) }
          it "declines a store" do
            within("store_#{store2.id}") do
              click_on "Decline"
            end
            page.should_not have_content (store2.name)
          end
        end
      end
    end
  end
end
