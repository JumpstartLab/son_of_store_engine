Fabricator(:customer) do
  stripe_token "StripeToken"
  user_id 1
  stripe_customer_token "CustomerToken"
  ship_address "herp"
  ship_address2 "derp"
  ship_state "herpa"
  ship_zipcode "12345"
  ship_city "alksdv"
end
