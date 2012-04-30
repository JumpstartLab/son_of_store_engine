require 'spec_helper'

describe 'Store Admin' do
  let!(:admin) { Fabricate(:admin_user) }
  let!(:user) { Fabricate(:user) }
  let(:super_admin_user) { Fabricate(:super_admin_user) }

  let!(:stores) do
    20.times.map do |n|
      Fabricate(:store, 
                :name => "store #{n}", 
                :slug => "store-#{n}", 
                :users => [admin])
    end
  end

  let!(:pending_store) { Fabricate(:store, :status => 'pending', :users => [admin]) }

  context 'unauthenticated user' do
    it 'redirects to root path' do
      visit superadmin_stores_path
      page.should have_content('You are not authorized to access this page.')
    end
  end

  context 'index page' do
    before(:each) do
      visit root_url
      login_as(super_admin_user)
      visit superadmin_stores_path
    end

    it 'is accessible by admin' do
      page.should have_content('Admin Store Index')
    end

    it 'contains a list of all stores' do
      stores.each do |store|
        page.should have_content(store.name)
        page.should have_content(store.slug)
        page.should have_content(store.description[0..28])
        page.should have_link(store.name)
      end
    end

    it 'has a link to administer' do
      page.should have_link('administer')
    end

    it 'has a link to approve' do
      page.should have_button('approve')
    end

    it 'has a link to decline' do
      page.should have_button('decline')
    end

    it 'does not have enable' do
      page.should_not have_button('enable')
    end

    context 'updates status by clicking on' do
      it 'disable' do
        click_button 'disable'
        page.should have_content('disabled')
      end

      it 'enable' do
        click_button 'disable'
        click_button 'enable'
        page.should have_content('active')
        click_link 'administer'
        page.should have_content('Dashboard')
      end

      it 'approve' do
        click_button 'approve'
        page.should have_content('active')
        click_link 'administer'
        page.should have_content('Dashboard')
      end

      it 'decline' do
        click_button 'decline'
        page.should_not have_content(pending_store.name)
        expect { visit products_path(pending_store) }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  context 'edit store' do
    before(:each) do
      login_as(admin)
      visit edit_admin_dashboard_path(stores.first)
    end

    it 'can be accessed' do
      page.should have_button('Update Store')
    end

    it 'can update name' do
      fill_in 'store_name', :with => 'Store 99'
      click_button 'Update Store'
      page.should have_content('Store 99')
      page.should_not have_content(stores.first.name)
    end

    it 'can update slug' do
      fill_in 'store_slug', :with => 'Store 99'
      click_button 'Update Store'
      current_path.should have_content('store-99')
    end

    it 'can update description' do
      fill_in 'store_description', :with => 'Store Description'
      click_button 'Update Store'
      page.should have_content('Store Description') 
    end

    it 'store name must be unique' do
      fill_in 'store_name', :with => stores.last.name
      click_button 'Update Store'
      page.should have_content('Name has already been taken')
    end

    it 'store slug must be unique' do
      fill_in 'store_slug', :with => stores.last.slug
      click_button 'Update Store'
      page.should have_content('Slug has already been taken')
    end
  end

  msg = "Store administrator works with products as in StoreEngine.
         https://www.pivotaltracker.com/story/show/28489023"
  pending msg do
    context "for a store with products" do
      it "creates a product, sees a flash message and a list of products"
      it "edits all attributes of a product, then see a flash and all my products"
      it "retires a product, then see a flash message and all my products"
    end
  end

  msg = "Store administrator adds new stocker.
         https://www.pivotaltracker.com/story/show/28489031"
  pending msg do
    context "adds a stocker" do
      it "by entering known email adds role of stocker to that user and emails"
      it "by entering unknown email invites that email to join as a stocker"
    end
  end


  msg = "Store admin removes stocker
         https://www.pivotaltracker.com/story/show/28489035"
  pending msg do
    context "with a stocker" do
      it "views a list of stockers on their admin page"
      it "can remove stockers from their store with a link on the admin page"
      it "when removing a stocker is prompted to confirm"
      it "after removing a stocker sees a confirmation flash message"
      it "after removing a stocker the user is emailed a notification"
      it "when removing stocker, and confirming, cancels and stocker lives on"
    end
  end
end
