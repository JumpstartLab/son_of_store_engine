FactoryGirl.define do
  factory :user do
    name     Faker::Name.name
    email    Faker::Internet.email
    display_name Faker::Internet.user_name
    password "foobar"
    password_confirmation "foobar"
  end
end