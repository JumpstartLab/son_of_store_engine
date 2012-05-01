Given /^I am a visitor to the store "([^"]*)"$/ do |name|
  @store = create(:store_with_products, name: name)
  visit_store(name)
end

Given /^I have added items to my cart$/ do
  product = @store.products.first
  visit new_cart_product_path(store_slug: @store.slug, id: product.id)
  @cart_products = [product]
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

Then /^I can continue to guest checkout where I can provide my email, billing, shipping, and credit card info to purchase directly$/ do
  page.should have_link "Continue to checkout as guest"
end

When /^I continue to guest checkout$/ do
  click_on "Continue to checkout as guest"
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

# http://127.0.0.1:63391/cool-sunglasses/guest_orders
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

Given /^I have a StoreEngine account$/ do
  @user = create(:user)
end

When /^I choose to sign in$/ do
  fill_in('Email', with: @user.email)
  fill_in('Password', with: @user.password)
  click_on('Log in')
end

Then /^I should be logged in$/ do
  page.should have_content "Sign out"
end

Then /^I am returned to my checkout process$/ do
  cart_link = find("a", text: /Cart \(\d+\)/)
  cart_count = cart_link.text[/\d+/].to_i

  cart_count.should == @cart_products.count
end

Then /^I can make my purchase normally$/ do
  #page.text.should include "Order Details"
  #page.should have_selector("h1", text: /Order Details/)
end

Given /^there is a store named "([^"]*)" with URL id "([^"]*)"$/ do |name, slug|
  @store = create(:store_with_products, name: name, slug: slug)
end

Given /^the store has a product named "([^"]*)"$/ do |name|
  create(:product, store: @store, name: name)
end

Given /^the store does not have a product "([^"]*)"$/ do |name|
  # express the regexp above with the code you wish you had
  Product.where(name: name, store_id: @store.id).first.try(:destroy)
end

When /^I browse its products$/ do
  click_on "Products"
end

Then /^I should see the product "([^"]*)"$/ do |product_name|
  page.should have_content product_name
end

Then /^I should not see the product "([^"]*)"$/ do |product_name|
  page.should_not have_content product_name
end

Given /^I am not logged in$/ do
  # No action needed. User starts out as signed out of an account.
  page.should_not have_content "Sign out"
end

Given /^that my email address is "([^"]*)"$/ do |email|
  @user = build(:user, first_name: 'Ed', last_name: 'Weng')
end

Given /^I have not created a StoreEngine account with my email address before$/ do
  User.where(email: @user.email).first.try(:destroy)
end

Given /^I follow the sign up link$/ do
  click_on "Register"
end

Then /^I should be on a top\-level page, "([^"]*)"$/ do |url|
  url = Addressable::URI.parse(url)
  current_path = URI.parse(current_url.split('?').first).path
  current_path.should == url.path
end

When /^I enter my email address, full name, and display name$/ do
  fill_in('user_email', with: @user.email)
  fill_in('user_name', with: @user.name)
  fill_in('user_display_name', with: @user.display_name)
  fill_in('user_password', with: @user.password)
  fill_in('user_password_confirmation', with: @user.password)
end

When /^I click the button or link to create my account$/ do
  click_on('Create Account')
end

Then /^I am returned to the page I was on$/ do
  start_page = Addressable::URI.parse(@start_page)
  current_path = URI.parse(current_url.split('?').first).path
  current_path.should == start_page.path
end

Then /^I should see a confirmation flash message with a link to change my account$/ do
  flash_text.should include "You have been registered."
  page.should have_selector "a", text: "Update your profile."
end

Then /^I should receive an email confirmation$/ do
  # XXX Use fixture.
  email = ActionMailer::Base.deliveries.last
  email.from.should == ["info@berrystore.com"]
  email.to.should == [@user.email]
  email.subject.to_s.should include "You have been registered."
end

Given /^I or someone else has created a StoreEngine account with my email address before$/ do
  @user = create(:user, first_name: 'Ed', last_name: 'Weng')  
end

Then /^I should see an error about duplicate email and a link to sign in$/ do
  flash_text.should include "Email has already been taken"  
end

Then /^I should be able to correct it and resubmit$/ do
  fill_in('user_email', with: 'ed.weng@gmail.com')
  fill_in('user_password', with: @user.password)
  fill_in('user_password_confirmation', with: @user.password)
  click_on('Create Account')
end

Given /^I enter my email address and display name$/ do
  fill_in('user_email', with: 'ed.weng@gmail.com')
  fill_in('user_display_name', with: @user.display_name)
  fill_in('user_password', with: @user.password)
  fill_in('user_password_confirmation', with: @user.password)
end

Then /^I should see an error telling me I need to specify a full name$/ do
  flash_text.should include "Name can't be blank"  
end

Given /^I enter my email address and full name$/ do
  fill_in('user_email', with: @user.email)
  fill_in('user_name', with: @user.name)
  fill_in('user_password', with: @user.password)
  fill_in('user_password_confirmation', with: @user.password)
end

Given /^I don't have a StoreEngine account$/ do
  # no action needed
end

When /^I choose to sign up$/ do
  click_on 'Register'
end

Then /^I am asked for my account information$/ do
  text.should include "Please enter your details"
end

When /^I create my account$/ do
  @user = build(:user)  
  fill_in('user_email', with: @user.email)
  fill_in('user_name', with: @user.name)
  fill_in('user_password', with: @user.password)
  fill_in('user_password_confirmation', with: @user.password)
  click_on 'Create Account'
end