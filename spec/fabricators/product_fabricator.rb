Fabricator(:product) do
  id rand(1..10)
  title "#{Faker::Company.catch_phrase}"
  description "#{Faker::Company.catch_phrase}"
  price rand(100..1000)
  categories [Category.new]
end