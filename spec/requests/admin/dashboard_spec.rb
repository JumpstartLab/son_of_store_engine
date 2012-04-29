require 'spec_helper'

describe "As an admin visiting the dashboard" do
  let!(:store) { Store.first }
  let!(:user) { FactoryGirl.create(:user, :admin => true) }
  let!(:store_admin2) { FactoryGirl.create(:user, :name => "store admin 2", :email => "admin2@worace.com", :admin => true) }
  let!(:new_store_admin) { FactoryGirl.create(:user, :name => "Worace the Third", :email => "admin3@worace.com", :admin => true) }

  context "and I'm not logged in" do
    before(:each) { visit admin_dashboard_path }
    it "redirects me to the signin page" do
      page.should have_content("Sign in")
    end
  end

  context "and I'm logged in" do
    let(:order_product) { FactoryGirl.create(:order_product) }
    let!(:pending_order) { FactoryGirl.create(:order,
      :user => user, :order_products => [order_product]) }
    before(:each) do

      set_host(store.url_name)
      store.add_admin(user)
      store.add_admin(store_admin2)

      visit "/sessions/new"
      fill_in "email", with: user.email
      fill_in "password", with: "foobar"
      click_link_or_button('Log in')
      visit admin_dashboard_path
    end


    it "lets me view the dashboard" do
      page.should have_content("Admin Dashboard")
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
end
