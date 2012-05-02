Given /^I am a Store administrator for "([^"]*)"$/ do |name|
  @store = create(:store_with_products_and_categories, name: name)
  @user = create(:store_admin, store: @store)
  log_in(@user)
end

Then /^I should be able to click to edit the store details$/ do
  page.should have_link "Edit #{@store.name}"
  click_on "Edit #{@store.name}"
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
  pending
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

Then /^I see a confirmation flash message$/ do
  pending # express the regexp above with the code you wish you had
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

Then /^an email is sent to "([^"]*)" to notify them they are an admin for "([^"]*)" and can access the admin page at "([^"]*)"http:\/\/storeengine\.com\/cool\-sunglasses\/admin"$/ do |arg1, arg2, arg3|
  pending # express the regexp above with the code you wish you had
end

Given /^"([^"]*)" has a StoreEngine user account$/ do |arg1|
  create(:user, email: email)
end

When /^I add the admin "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end