Given /^I am a logged in StoreEngine user$/ do
  @user = log_in_as_site_admin
  log_in(@user)
end

Then /^I click to create a new store$/ do
  click_on("Add new store")
end

Given /^there is already a store called "([^"]*)"$/ do |name|
  @store = create(:store, name: name)
end

When /^I am creating a new store$/ do
  visit("/profile")
  click_on("Add new store")
end

When /^I enter a store name, store URL identifier, and store description as "([^"]*)", "([^"]*)", and "([^"]*)"$/ do |name, slug, description|
  fill_in "store_name",        with: name
  fill_in "store_description", with: description
  fill_in "store_slug",        with: slug

  @store_name        = name
  @store_description = description
  @store_slug        = slug
end

When /^I create the store$/ do
  click_on("Create")
end

Then /^I should see an error about the duplicate name$/ do
  flash_text.should include "Name has already been taken"
end

Then /^I should be able to correct the error$/ do
  page.should have_css("#store_name")
end

Given /^there is already a store with URL id "([^"]*)"$/ do |slug|
  create(:store, slug: slug)
end

Then /^I should see an error about the duplicate URL id$/ do
  flash_text.should include "Slug has already been taken"
end

Then /^I should see a confirmation of my store details$/ do
  page.text.should include "Name: #{@store_name}"
end

Then /^I should see that my new store is pending approval$/ do
  page.text.should include "Status: pending"
end

Then /^I should see a not found error$/ do
  flash_text.should include "A store does not exist at this address."
end

Then /^I am signed in$/ do
  page.text.should include "Sign out"
end
