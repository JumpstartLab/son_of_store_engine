 FactoryGirl.define do
  factory :user do 
    sequence(:display_name) { Faker::Name.name }
    password "foobar"
    name "foo"
    sequence(:email) { |n| "display_name#{n}@example.com"}
    permission 1

    factory :admin do
      permission 9
    end
  end
  factory :cart do
    is_cart true
  end

  factory :store do
    sequence(:name) { |n| "store#{n}" }
    sequence(:url) { |n| "url#{n}" }
    active 2
    enabled true
  end

  factory :status do
    name "shipped"
  end

  factory :order do
    user
    status
    is_cart false
    store
  end

  factory :product_rating do
    body "hello"
    name "AWESOME PRODUCT"
    rating 4
  end
  factory :order_product do
    quantity 1
  end

  factory :product do
    sequence(:name) { |n| "product#{n}" }
    description "yummy foo"
    price_in_cents { Random.rand * 10000 }
    store
  end

  factory :category do
    sequence(:name) { |n| "category#{n}" }
    store
  end
  factory :address do
    street "1375 Kenyon Street NW"
    zipcode "20010"
    state "DC"
  end
  factory :sale do
    end_at 30.days.from_now
    percent_off 30
    store
  end

end