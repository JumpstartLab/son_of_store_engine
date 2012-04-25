# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :visitor_user do
    sequence(:email) { |n| "person#{n}@example.com" }
  end
end
