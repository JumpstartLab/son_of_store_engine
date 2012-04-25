FactoryGirl.define do
  
  factory :product do
    sequence(:title)  { |n| "New Product ##{n}" } 
    description Faker::Lorem.paragraph(sentence_count = 3)
    price 500 
  end

  factory :category do
    title "New Category"
  end

  factory :cart_item do
    quantity { rand(1..100) } 
  end

  factory :order_item do
    quantity { rand(1..100) }
    product
    order
  end

  factory :user do
    full_name Faker::Name.name
    password "foo"
    password_confirmation "foo"
    username Faker::Name.first_name
    sequence(:email) { |n| "user#{n}@example.com" } 
  end

  factory :order do
    user
    status "pending"
    factory :order_with_items do
      ignore do
        order_item_count 5
      end
      after_create do |order, evaluator|
        FactoryGirl.create_list(:order, evaluator.order_item_count, order: order)
      end
    end
  end


  factory :cart do
  end

  factory :address do
    street_1 Faker::Address.street_address
    zip_code "20001"
    city     Faker::Address.city
    state    Faker::Address.state_abbr
    association :user
  end

  factory :store do
    name "Top Funky"
    slug "top_funky"
    owner_id 1 #FactoryGirl.create(:user).id
  end
end