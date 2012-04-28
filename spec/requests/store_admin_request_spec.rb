require 'spec_helper'

describe 'Store Admin' do
  let!(:admin) { Fabricate(:user, :role => 'admin') }
  let!(:user) { Fabricate(:user) }

  let!(:stores) do
    20.times.map do |n|
      Fabricate(:store, 
                :name => "store #{n}", 
                :store_unique_id => "store-#{n}", 
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
        page.should have_content(store.store_unique_id)
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

    context 'updates status by clicking on' do
      it 'enable' do
        click_button 'enable'
        page.should have_content('active')
        click_link 'administer'
        page.should have_content('Dashboard')
      end

      it 'disable' do
        click_button 'disable'
        page.should have_content('disabled')
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

end