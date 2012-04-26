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
      it "can't visit admin path" do
        visit admin_stores_path
        page.should have_content "Must be site administrator"
      end
      context "create a store" do
        it "Passes" do
          visit new_admin_store_path
          fill_in 'store[name]', :with => "my test store"
          fill_in 'store[description]', :with => "My AWESOME store"
          fill_in 'store[description]', :with => "My AWESOME store"
          fill_in 'store[url]', :with => 'my-test-store'
          click_on 'Create Store'
          page.should have_content "Store was successfully created."
        end
        it "fails" do
          visit new_admin_store_path
          fill_in 'store[name]', :with => ""
          fill_in 'store[description]', :with => ""
          fill_in 'store[description]', :with => ""
          fill_in 'store[url]', :with => ''
          click_on 'Create Store'
          page.should have_content "There was an error while creating your store."
        end
      end
      context "updates a store" do
        let!(:update_store) { FactoryGirl.create(:store, :users => [user]) }
        it "Passes" do
          visit edit_admin_store_path(update_store)
          fill_in 'store[name]', :with => "my test store"
          fill_in 'store[description]', :with => "My AWESOME store"
          fill_in 'store[description]', :with => "My AWESOME store"
          fill_in 'store[url]', :with => 'my-test-store'
          click_on 'Update Store'
          page.should have_content "Store was successfully updated."
        end
        it "fails" do
          visit edit_admin_store_path(update_store)
          fill_in 'store[name]', :with => ""
          fill_in 'store[description]', :with => ""
          fill_in 'store[description]', :with => ""
          fill_in 'store[url]', :with => ''
          click_on 'Update Store'
          page.should have_content "There was an error while updating your store."
        end
      end      
      it "Store created should not be live" do
        visit "http://my-test-store.son.test"
        page.should have_content "page you were looking"
      end
      context "approve store as admin" do
        let!(:store1) { FactoryGirl.create(:store, :active => 1, :enabled => false, :users => [user]) }
        let!(:store2) { FactoryGirl.create(:store, :active => 1, :enabled => false, :users => [user]) }
        let!(:store3) { FactoryGirl.create(:store, :active => 2, :enabled => false, :users => [user]) }
        let!(:store4) { FactoryGirl.create(:store, :active => 2, :enabled => true, :users => [user]) }
        let!(:store5) { FactoryGirl.create(:store, :active => 2, :enabled => true, :users => [user]) }        
        before(:each) do
          visit '/logout'
          login(admin)
          visit admin_stores_path
        end
        context "Enabling" do
          it "should be able to approve a store" do
            within("#store_#{store1.id}") do
              click_on "Approve"
            end
            page.should have_content "#{store1.name} Successfully Approved"
          end
          it "and then enable a store" do   
             within("#store_#{store3.id}") do
               click_on "Enable"
             end
             page.should have_content "#{store3.name} Successfully Enabled"
          end
          it "should now be able to see the store" do
            visit "http://#{store4.url}.son.test"
            page.should have_content "Products"
          end
        end
        context "Disabling" do
          it "disables a store" do
            within("#store_#{store5.id}") do
              click_on "Disable"
            end
            page.should have_content "Successfully Disabled"
          end
          it "and then the store is no longer showed" do
            visit "http://my-test-store.son.test"
            page.should have_content "page you were looking"            
          end
        end
        context "Disapprove a store" do
          it "declines a store" do
            within("#store_#{store2.id}") do
              click_on "Decline"
            end
            page.should have_content ("Successfully Declined")
          end
        end
      end
    end
  end
end
