Fabricator(:store, :class_name => Store) do
  name   { "#{Faker::Company.name}#{sequence}" }
  domain { "#{Faker::Company.name.downcase.gsub(" ", "")}#{sequence}" }
  description "#{ Faker::Company.catch_phrase } #{ Faker::Company.catch_phrase } #{ Faker::Company.catch_phrase }"
  approval_status "approved"
  enabled true
  creating_user_id  { Fabricate(:user).id }
end
