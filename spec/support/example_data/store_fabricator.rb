Fabricator(:store, :class_name => Store) do
  name   { Faker::Company.name }
  domain { Faker::Company.name.downcase.gsub(" ", "") }
  description "#{ Faker::Company.catch_phrase } #{ Faker::Company.catch_phrase } #{ Faker::Company.catch_phrase }"
  approval_status "approved"
  enabled true
  creating_user_id 1
end
