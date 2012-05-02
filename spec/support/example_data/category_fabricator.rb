Fabricator(:category, :class_name => Category) do
  name { Faker::Company::bs }
end