Given /^I am a Stocker for the store "([^"]*)"$/ do |store_name|
  @store = create(:store_with_products_and_categories, name: store_name)
  @user = log_in_as_store_stocker(@store)

end

Then /^I am able to add a new product like a store admin$/ do
  fill_in 'product_name', with: 'The Ed Weng'
  fill_in 'product_price', with: '10.00'
  fill_in 'product_description', with: 'A very rich and compelling man.'
  fill_in 'product_photo', with: 'http://i.imgur.com/i1P5C.jpg'
  check @store.categories.first.name
  check @store.categories.last.name
end

When /^I save the product$/ do
  click_on "Create Product"
end

Then /^I am able to change the details \(name, description, price, photo URL\) like a store admin$/ do
  fill_in 'product_name', with: 'The Ed Weng'
  fill_in 'product_price', with: '10.00'
  fill_in 'product_description', with: 'A very rich and compelling man.'
  fill_in 'product_photo', with: 'http://i.imgur.com/i1P5C.jpg'
  click_on('Update Product')
end

Then /^that product is retired, as in the original StoreEngine requirements$/ do
  @store.retired_products.size.should == 1
end