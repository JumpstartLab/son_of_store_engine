Given /^I am a Store administrator for "([^"]*)"$/ do |name|
  @store = create(:store_with_products_and_categories, name: name)
  @user = create(:store_admin, store: @store)
  log_in(@user)
end

Then /^I should be able to click to edit the store details$/ do
  page.should have_link "(Edit)"
  click_on "(Edit)"
end

When /^I am editing the store$/ do
  text.should include "Edit Store"
end

When /^I change the store name$/ do
  fill_in "name", with: "BOOM"
end

When /^I update the store$/ do
  click_on 'Update Store'
end

When /^I should see a confirmation flash message with "([^"]*)"$/ do |message|
  flash_text.should include message
  @old_store = @store
  @store = Store.last
end

When /^I should be able to find the new store name$/ do
  text.should include "BOOM"
end

When /^I should not be able to find the old store name$/ do
  text.should_not include @old_store.name
end

When /^I change the store URL id$/ do
  fill_in "New URL", with: "boom"
end

Then /^I should be asked to confirm I want to change the URL id$/ do
  flash_text.should include "Are you sure you want to change the store URL"
end

Then /^I should be warned about breaking existing links$/ do
  flash_text.should include "This action could break external links"
end

Then /^I should have the option to cancel or confirm my action$/ do
  page.should have_link "Confirm"
  page.should have_link "Cancel"
end

When /^I am being asked about confirming the change to a store URL id$/ do
  fill_in "New URL", with: "boom"
  click_on 'Update Store'
end

When /^I choose to cancel$/ do
  click_on "Cancel"
end

Then /^I should be viewing the edit store page$/ do
  text.should include "Edit Store"
end

Then /^the previous store URL id should be shown$/ do
  page.find_field('new_slug').value.should == @store.slug
end

When /^I choose to confirm$/ do
  click_on "Confirm"
end

Then /^I should see my store admin section$/ do
  text.should include "Admin Dashboard"
end

Then /^the new store URL id should be displayed$/ do
  text.should include "boom"
end

Given /^there are products in stock for my store$/ do
  @store.products.size.should be > 0
end

Then /^I should see the list of products for my store$/ do
  text.should include "Admin Products"
  @store.products.each_with_index do |product, idx|
    page.should have_content(product.name) if idx < 20
  end
end


When /^I click "([^"]*)"$/ do |button|
  click_on button
end

Then /^I am able to add a new product like I could in StoreEngine v(\d+)$/ do |version|
  fill_in 'product_name', with: 'The Ed Weng'
  fill_in 'product_price', with: '10.00'
  fill_in 'product_description', with: 'A very rich and compelling man.'
  fill_in 'product_photo', with: 'http://i.imgur.com/i1P5C.jpg'
  check @store.categories.first.name
  check @store.categories.last.name
  click_on "Create Product"
end

When /^I click "([^"]*)" for an existing product$/ do |action|
  click_on action.capitalize
end

Then /^I am able to change the details \(name, description, price, photo URL\) like I could in StoreEngine v(\d+)$/ do |arg1|
  fill_in 'product_name', with: 'The Ed Weng'
  fill_in 'product_price', with: '10.00'
  fill_in 'product_description', with: 'A very rich and compelling man.'
  fill_in 'product_photo', with: 'http://i.imgur.com/i1P5C.jpg'
end

When /^I save my changes$/ do
  click_on "Update Product"
end

Then /^that product is retired, as in StoreEngine v(\d+)$/ do |arg1|
  @store.retired_products.size.should == 1
end

Given /^I to click to add a new store admin$/ do
  click_on "Add new store admin"
end

Then /^an email is sent to "([^"]*)" to notify them they are an admin for "([^"]*)" and can access the admin page at "([^"]*)"http:\/\/storeengine\.com\/cool\-sunglasses\/admin"$/ do |email, store_name, uri|
  user = User.where(email: email).first
  Resque.peek(:emails, 0, 100).last["args"].should == ["store_admin_addition_notification", user.id]
end

Given /^"([^"]*)" has a StoreEngine user account$/ do |email|
  create(:user, email: email)
end

When /^I add the admin "([^"]*)"$/ do |email|
  fill_in 'user_email', with: email
  click_on 'Create Account'
end

When /^"([^"]*)" does not have a StoreEngine user account$/ do |email|
  @email = email
  User.where(email: email).should be_empty
end

Then /^an email is sent to "([^"]*)" inviting them to sign up for a StoreEngine account with a sign up link$/ do |email|
  Resque.peek(:emails, 0, 5).last["args"].should == ["signup_notification", @email]
end

Given /^there is another admin with email "([^"]*)"$/ do |email|
  create(:store_admin, email: email, store: @store)
end

When /^I click "([^"]*)" for the admin "([^"]*)"$/ do |action, email|
  click_link(email)
end

Then /^I am asked to confirm the removal$/ do
  page.driver.browser.window_handles.size == 2
end

When /^I confirm it$/ do
  page.driver.browser.switch_to.alert.accept
end

Then /^I am viewing the admin page$/ do
  text.should include 'Admin Dashboard'
end

Then /^"([^"]*)" does not show as an admin$/ do |email|
  text.should_not include email
end

Then /^"([^"]*)" is sent an email notification$/ do |email|
  Resque.peek(:emails, 0, 100).last["args"].should == ["store_admin_removal_notification", User.where(email: email).first.id]
end

When /^I cancel it$/ do
  page.driver.browser.switch_to.alert.dismiss
end

Then /^"([^"]*)" shows as an admin$/ do |email|
  within find('tr', title: email).parent do
    text.should include 'Store admin'
  end
end

Given /^I to click to add a new stocker$/ do
  click_on 'Add stocker'
end

When /^I add the stocker "([^"]*)"$/ do |email|
  fill_in 'user_email', with: email
  click_on 'Create Account'
end

Then /^an email is sent to "([^"]*)" to notify them they are a stocker for "([^"]*)" and can access the admin page at "([^"]*)"http:\/\/storeengine\.com\/cool\-sunglasses\/stock\/products"$/ do |email, store, url|
  user = User.where(email: email).first
  Resque.peek(:emails, 0, 100).last["args"].should == ["store_stocker_addition_notification", user.id]
end

Given /^there is stocker with email "([^"]*)"$/ do |email|
  create(:store_stocker, email: email, store: @store)
end

When /^I click "([^"]*)" for the stocker "([^"]*)"$/ do |action, email|
  click_link(email)
end

Then /^"([^"]*)" does not show as a stocker$/ do |email|
  within find('tr', title: email).parent do
    text.should_not include 'Store stocker'
  end
end

Then /^"([^"]*)" shows as a stocker$/ do |email|
  within find('tr', title: email).parent do
    text.should include 'Store stocker'
  end
end

Then /^an email is sent to "([^"]*)" to notify them they are no longer a stocker for "([^"]*)"$/ do |email, store|
  user = User.where(email: email).first
  Resque.peek(:emails, 0, 100).last["args"].should == ["store_stocker_removal_notification", user.id]
end