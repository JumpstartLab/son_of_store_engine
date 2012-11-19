Fabricator(:product, :class_name => Product) do
  title { [Faker::Lorem.words(1),sequence].join }
  description { Faker::Lorem.words(1).join }
  price { ((rand * 100) + 1).to_s }
  photo_url { nil }
end