require 'spec_helper'

describe "Store" do
  let!(:user) { Fabricate(:user) }
  let!(:pending_store) { Fabricate(:store, :status => 'pending', :users => [user]) }
  let!(:store) { Fabricate(:store, :name => 'Some 1000', :slug => 'some-1000') }
  let!(:store_second) { Fabricate(:store, :name => "Some 2000", :slug => 'some-2000') }
  let!(:disabled_store) { Fabricate(:store, :name => "Some 3", :slug => 'some-3', :status => 'disabled') }
  let!(:product_store_1) { Fabricate(:product, :store => store) }
  let!(:product_store_2) { Fabricate(:product, :store => store_second) }

  before(:each) do 
    visit root_url
    login_as(user)
  end

  it 'has a create store link on main page' do
    click_link 'Create A Store'
    page.should have_button('Create Store')
  end

  context 'fills out the create store form' do
    before(:each) do
      click_link 'Create A Store'
    end

    it 'has a name' do
      fill_in "store[slug]", :with => 'some-store'
      fill_in 'store[description]', :with => 'Some Description'
      click_button 'Create Store'
      page.should have_content("Name can't be blank")
    end

    it 'has a unique store id' do
      fill_in 'store[name]', :with => 'Some Store'
      fill_in 'store[description]', :with => 'Some Description'
      click_button 'Create Store'
      page.should have_content("Slug can't be blank")
    end

    it 'has a unique store id' do
      fill_in 'store[name]', :with => 'Some Store'
      fill_in "store[slug]", :with => 'some-store'
      fill_in 'store[description]', :with => 'Some Description'
      click_button 'Create Store'

      visit new_store_path
      fill_in 'store[name]', :with => 'Some Store'
      fill_in "store[slug]", :with => 'some-store'
      fill_in 'store[description]', :with => 'Some Description'
      click_button 'Create Store'

      page.should have_content("Name has already been taken")
      page.should have_content("Slug has already been taken")
    end
  end

  it 'pending store is not accessible' do
    expect { visit products_path(pending_store) }.to raise_error(ActionController::RoutingError)
  end

  it 'is accessible' do
    visit products_path(store)
    page.should have_content(store.name)
  end

  it 'is down for maintenance' do
    visit products_path(disabled_store)
    page.should have_content('Store is down for maintenance')
  end

  it 'stores have different products' do
    visit products_path(store)
    page.should_not have_content(product_store_2.title)
    page.should have_content(product_store_1.title)
  end

  it 'has a valid store page' do
    visit "/#{store.to_param}"
    page.should have_content(store.name)
  end
end