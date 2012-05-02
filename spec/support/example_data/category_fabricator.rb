Fabricator(:category, :class_name => Category) do
  name { [Faker::Lorem.words(2),sequence].join(" ") }
end
