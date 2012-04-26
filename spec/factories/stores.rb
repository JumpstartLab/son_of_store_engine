# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
 factory :store do
   name { Faker::Name.name }
   description { Faker::Lorem.words(num = 10).join(' ') }
   slug { "#{name}".downcase.gsub(' ', '-') }
 end
end
