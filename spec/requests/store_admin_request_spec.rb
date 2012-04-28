require 'spec_helper'

describe 'Store Admin' do
  let!(:admin) { Fabricate(:user, :role => 'admin') }
  let!(:user) { Fabricate(:user) }

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
      login_as(user)
      visit superadmin_stores_path
      page.should have_content('Access denied. This page is for administrators only.')
    end
  end

  context 'index page' do
    before(:each) do
      visit root_url
      login_as(admin)
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

end