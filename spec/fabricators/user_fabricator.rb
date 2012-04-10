Fabricator(:user) do
  email "#{ Faker::Internet.email }"
  password "#{ Faker::Company.catch_phrase }"
  id rand(10)
  name "#{ Faker::Name.name }"
end
