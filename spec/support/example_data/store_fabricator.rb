Fabricator(:store, :class_name => Store) do
  name   { Faker::Lorem.words(1).first }
  domain { Faker::Lorem.words(1).first }
  enabled { true }
end
