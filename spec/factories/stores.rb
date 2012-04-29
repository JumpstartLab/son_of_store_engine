# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :store do
    name "Cool Beans"
    url_name "cool-beans"
    description "Buy our beans!"
  end
end
