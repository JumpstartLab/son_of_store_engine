# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :privilege do
    user_id 1
    store_id 1
    name "MyString"
  end
end
