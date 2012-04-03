Fabricator(:product) do
  title "#{Faker::Name.first_name} #{Faker::Name.last_name}"
  description "#{Faker::Company.catch_phrase}"
  price rand(100..1000)
end