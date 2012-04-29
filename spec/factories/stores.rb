# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :store do
    name "Best Sunglasses"
    url_name "best-sunglasses"
    description "Buy our sunglasses!"
    approved false
    enabled false
  end
end
