# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :store do
    name "Testberry"
    description "My tasty tests."
    slug "testberry"
  end
end
