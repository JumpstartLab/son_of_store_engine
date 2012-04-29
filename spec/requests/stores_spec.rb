require 'spec_helper'

describe "Creating stores" do
  let!(:user) { FactoryGirl.create(:user, :admin => true) }

  context "and I'm logged in" do
    before(:each) do
      #set_host("woraces-workshop")
      visit "/sessions/new"
      fill_in "email", with: user.email
      fill_in "password", with: "foobar"
      click_link_or_button('Log in')
      visit user_path(user)
    end

    it "lets me create a store from my profile page" do
      page.should have_content('Create a store')
    end

    context "and I click 'Create a store'" do
      before(:each) { click_link_or_button('Create a store') }

      it "takes me to the new store creation page" do
        page.should have_content('New store')
      end

      context "and I submit invalid information" do
        it "does not let me create a store with duplicate information" do
          fill_in "store_name", with: "Best Sunglasses"
          fill_in "store_url_name", with: "sunglasses"
          fill_in "store_description", with: "Buy our sunglasses!"
          click_link_or_button('Create Store')
          page.should have_content("Name has already been taken")
        end
      end

      context "and I enter valid information" do

        before do
          fill_in "store_name", with: "Cool Sunglasses"
          fill_in "store_url_name", with: "cool-sunglasses"
          fill_in "store_description", with: "Buy our sunglasses!"
        end

        it "creates a new store" do
          expect {click_link_or_button('Create Store')}.to change(Store, :count).by(1)
        end

        context "and the store has not been approved" do
          before(:each) do
            click_link_or_button('Create Store')
            set_host("cool-sunglasses")
          end

          it "does not let me view the store" do
            #ARG NEED TO FIGURE HOW TO ACCESS RESPONSES
            visit('/')
            page.should have_content("404 Not Found")
          end
        end
      end

      context "and I'm an admin viewing stores" do
        before(:each) { visit admin_stores_path }

        it "shows me all of the stores in the system" do
          Store.all.each do |store|
            page.should have_content(store.name)
            page.should have_content(store.url_name)
          end
        end

        context "and I click to decline a store" do
          before(:each) { click_link_or_button('Decline this store')}

          it "declines the store" do
            Store.last.approved.should == false
          end

          it "emails the store owner of the decline"
        end

        context "and I click to approve a store" do
          before(:each) { click_link_or_button('Approve this store')}

          it "approves the store" do
            Store.last.approved.should == true
          end

          it "flashes a confirmation message" do
            page.should have_content("was updated!")
          end

          it "emails the store owner that the store was approved"

          context "and I want to disable the store" do
            before(:each) { click_link_or_button('Disable this store') }
            
            it "disables the store" do
              Store.first.disabled.should == true
            end

            context "and I want to enable the store" do
              before(:each) { click_link_or_button('Enable this store') }

              it "enables the store" do
                Store.first.enabled?.should == true
              end

              context "and I visit the store" do
                before(:each) { set_host("test-store") }

                it "has a live page for the store" do
                  visit '/'
                  page.should have_content('Browse by category')
                end
              end
            end
          end
        end
      end
    end
  end
end