require "addressable/uri"

Given /^I am a StoreEngine administrator$/ do
  @user = log_in_as_site_admin
end

Given /^a store "([^"]*)" has been created and is pending approval$/ do |name|
  @store = create(:store, name: name, status: "pending", users: [@user])
end

Given /^I visit "([^"]*)"$/ do |uri|
  uri = Addressable::URI.parse(uri)
  url = uri.path
  url += "?" + uri.query if uri.query

  @start_page = url # for some tests to check redirection
  visit(url)
end

When /^I click "([^"]*)" for "([^"]*)"$/ do |action, store|
  # XXX we'll probably need to be smarter about this
  # after we implement subdomains and/or domains
  @action = action + "d"
  slug    = @store.slug
  button  = "#{slug}-#{action}"

  click_on(button)
end

Then /^I should see a confirmation flash message$/ do
  message = "Store has been"
  flash_text.should include message
end

Then /^I should see the "([^"]*)" in the list of stores$/ do |name|
  text.should include name
end

Then /^I should not see the "([^"]*)" in the list of stores$/ do |name|
  page.all("table").each do |table|
    table.text.should_not include name
  end
end

Then /^I should not see the option to "approve" or "decline" it$/ do
  slug = @store.slug
  actions = ["approve", "decline"]
  actions.each do |action|
    button_id = "##{slug}-#{action}"
    page.should have_no_selector button_id
  end
end

Then /^the user who requested approval is notified of the acceptance$/ do
  # XXX use a fixture for the email contents
  # email = ActionMailer::Base.deliveries.first
  # email.from.should == ["info@berrystore.com"]
  # email.to.should == [@user.email]
  # email.subject.to_s.should include "Your store has been approved"
  Resque.peek(:emails)["args"].first.should == @store.id
end

Then /^the user who requested approval is notified of the decline/ do
  # XXX use a fixture for the email contents
  Resque.peek(:emails)["args"].first.should == @store.id
end

Given /^a store "([^"]*)" has been approved and is enabled$/ do |name|
  @store = create(:store, name: name, status: "approved", users: [@user])
end

When /^I click "([^"]*)" for the store "([^"]*)"$/ do |action, store|
  within find('tr', text: Store.where(name: store).first.slug) do
    click_on action.capitalize
  end
end

Then /^I am viewing the admin list of stores$/ do
  text.should include "Stores Control Panel"
end

Then /^I see a disabled confirmation flash message$/ do
  message = "Store has been disabled."
  flash_text.should include message
end

Then /^I can see an option to "([^"]*)" the store "([^"]*)"$/ do |action, store|
  within find('tr', text: Store.where(name: store).first.slug) do
    have_link action.capitalize
  end
end

Then /^I should see a page informing me the site is currently down for maintenance$/ do
  flash_text.should include "This site is currently down for maintenence."
end

Given /^a store "([^"]*)" has been approved but is disabled$/ do |name|
  @store = create(:store, name: name, status: "disabled", users: [@user])
end

Then /^I should see products for the store "([^"]*)"$/ do |store_name|
  store = Store.where(name: store_name).first
  store.products.all.each do |product|
    page.should have_content(product.name)
  end
end