Given /^I am a Store administrator for "([^"]*)"$/ do |name|
  @store = create(:store, name: name, status: 'approved')
  @user = create(:store_admin, store: @store)
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
  flash.text.should include "Are you sure you want to change the store URL"
end

Then /^I should be warned about breaking existing links$/ do
  flash.text.should include "This action could break external links"
end

Then /^I should have the option to cancel or confirm my action$/ do
  flash.should have_link "Confirm"
  flash.should have_link "Cancel"
end

When /^I am being asked about confirming the change to a store URL id$/ do
  pending # express the regexp above with the code you wish you had
end