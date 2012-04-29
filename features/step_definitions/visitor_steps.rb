Given /^I am a visitor to the store "([^"]*)"$/ do |name|
  @store = create(:store_with_products, name: name)
  visit_store(name)
end

Given /^I have added items to my cart$/ do
  product = @store.products.first
  visit new_cart_product_path(store_slug: @store.slug, id: product.id)
end

When /^I checkout$/ do
  find('a', text: /Cart \(\d+\)/).click
  click_on("Checkout")
end

Then /^I can sign up for an account$/ do
  find('a', text: "Register")
end

Then /^I can sign in to my existing account$/ do
  find('input', value: "Log in")
end

Then /^I can provide my email, billing, shipping, and credit card info to purchase directly$/ do
  click_on("Continue to checkout as guest")
  page.should have_selector("#new_guest_user")
end

When /^I provide my info directly:$/ do |table|
  table = table.hashes.first
  @email = table["email"]

  fill_in "guest_user_name",                   with: table["name"]
  fill_in "guest_user_email",                  with: table["email"]
  fill_in "card_number",                       with: table["card"]
  fill_in "card_code",                         with: table["cvv"]
  select  table["month"],                      from: "card_month"
  select  table["year"],                       from: "card_year"
  fill_in "shipping_detail_ship_to_name",      with: table["name"]
  fill_in "shipping_detail_ship_to_address_1", with: table["address"]
  fill_in "shipping_detail_ship_to_city",      with: table["city"]
  select  table["state"],                      from: "shipping_detail_ship_to_state"
  fill_in "shipping_detail_ship_to_zip",       with: table["zipcode"]
end

When /^I purchase my order$/ do
  click_on "Place Order"
end

# XXX I'm not sure if this qualifies as "hashed": /crackberry/orders/14
Then /^I am shown a confirmation page with a unique, hashed URL that displays my order details$/ do
  flash_text.should include "Thank you for placing an order."
end

Then /^I receive an email with my order details and the unique URL for later viewing$/ do
  # XXX use a fixture for the email contents
  email = ActionMailer::Base.deliveries.first
  email.from.should == ["info@berrystore.com"]
  email.to.should == [@email]
  email.subject.to_s.should include "Your Recent Mittenberry Purchase"
end
