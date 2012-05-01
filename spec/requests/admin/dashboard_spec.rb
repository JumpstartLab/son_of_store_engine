require 'spec_helper'

describe "As an admin visiting the dashboard" do
  let(:store) { Store.first }
  let(:user) { FactoryGirl.create(:user, :admin => true) }
  let(:store_admin2) { FactoryGirl.create(:user, :name => "store admin 2", :email => "admin2@worace.com", :admin => false) }
  let(:new_store_admin) { FactoryGirl.create(:user, :name => "Worace the Third", :email => "admin3@worace.com", :admin => false) }
  let(:new_store_stocker) { FactoryGirl.create(:user, :name => "Worace the Fourth", :email => "stocker1@worace.cim", :admin => false) }
  let(:store_stocker2) { FactoryGirl.create(:user, :name => "store stocker 2", :email => "stocker2@worace.cim", :admin => false) }

  before do
    set_host(store.url_name)
  end

  context "and I'm not logged in" do
    before(:each) { visit admin_dashboard_path }
    it "redirects me to the signin page" do
      page.should have_content("Sign in")
    end
  end

  context "and I'm logged in as an admin" do
    let(:order_product) { FactoryGirl.create(:order_product) }
    let!(:pending_order) { FactoryGirl.create(:order,
      :user => user, :order_products => [order_product]) }
    before(:each) do

      store.add_admin(store_admin2)
      store.add_admin(user)
      store.add_stocker(store_stocker2)

      visit "/sessions/new"
      fill_in "email", with: user.email
      fill_in "password", with: "foobar"
      click_link_or_button('Log in')
      visit admin_dashboard_path
    end

    it "lets me view the dashboard" do
      page.should have_content("Admin Dashboard")
    end

    context "when working with admins" do
      before(:each) do
      end

      it "lets me create a new admin for my awesome store" do
        within("#admins") do
          fill_in "new_admin_email_address", with: new_store_admin.email
          click_link_or_button('Add Admin')
        end
        within("#admins") do
          page.should have_content(new_store_admin.name)
        end
      end

      it "lists the admins for the current store" do
        store.admins.each do |admin|
          page.should have_content(admin.email)
        end
      end

      it "has a link to remove a non-owner admin" do
        store.admins.each do |admin|
          within("#admin_#{admin.id}") do
            unless store.owner == admin || admin == user
              page.should have_link("Remove Admin")
            end
          end
        end
      end

      it "prevents me from removing myself" do
        within("#admin_#{user.id}") do
          page.should_not have_link("Remove Admin")
        end
      end

      it "removes the admin" do
        within("#admin_#{store_admin2.id}") do
          click_link_or_button "Remove Admin"
        end
        within("#admins") do
          page.should_not have_content(store_admin2.name)
        end
      end
    end

    context "when working with stockers as an admin" do


      it "has a section for listing stockers" do
        within("#stockers") do
          page.should have_content("Stockers for #{store.name}")
        end
      end

      it "lets me create a new stocker for my awesome store" do
        within("#stockers") do
          fill_in "new_stocker_email_address", with: new_store_stocker.email
          click_link_or_button('Add Stocker')
        end
        within("#stockers") do
          page.should have_content(new_store_stocker.name)
        end
      end

      it "lists the stockers for the current store" do
        store.stockers.each do |stocker|
          page.should have_content(stocker.email)
        end
      end

      it "has a link to remove a non-owner admin" do
        store.stockers.each do |stocker|
          within("#stocker_#{stocker.id}") do
            unless store.owner == stocker || stocker == user
              page.should have_link("Remove Stocker")
            end
          end
        end
      end

      it "removes the stocker" do
        within("#stocker_#{store_stocker2.id}") do
          click_link_or_button "Remove Stocker"
        end
        within("#admins") do
          page.should_not have_content(store_stocker2.name)
        end
      end
    end
  end
end
