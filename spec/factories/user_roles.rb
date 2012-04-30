# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_role do
    user_id 1
    role "MyString"
    store_id 1
  end
end
