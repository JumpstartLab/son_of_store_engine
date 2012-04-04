Fabricator(:product) do
  title "#{Faker::Company.catch_phrase}"
  description "#{Faker::Company.catch_phrase}"
  price rand(100..1000)
end