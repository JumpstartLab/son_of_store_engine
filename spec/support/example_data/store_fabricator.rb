Fabricator(:store, :class_name => Store) do
  name   { Faker::Company.name }
  domain { Faker::Company.name.downcase.strip }
  description "#{ Faker::Company.catch_phrase } #{ Faker::Company.catch_phrase } #{ Faker::Company.catch_phrase }"
  approval_status "approved"
  enabled true
end
