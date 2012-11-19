# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shipping_detail do
    ship_to_name "Meh"
    ship_to_address_1 "1234 Wah St"
    ship_to_city "Washington"
    ship_to_state "DC"
    ship_to_country "USA"
    ship_to_zip "20001"
  end
end
