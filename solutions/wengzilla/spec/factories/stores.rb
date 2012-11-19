# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :store do
    name        { Faker::Name.name }
    description { Faker::Lorem.words(10).join(' ') }
    slug        { "#{name}".downcase.gsub(' ', '-') }
    status      "pending"
  end

  factory :store_with_products, parent: :store do
    status "approved"

    ignore do
      product_count 5
    end

    after_create do |store, evaluator|
      store.users << FactoryGirl.create(:user)
      FactoryGirl.create_list(
        :product,
        evaluator.product_count,
        store: store)
    end
  end

  factory :store_with_products_and_categories, parent: :store_with_products do
    after_create do |store, evaluator|
      FactoryGirl.create_list(
        :category,
        5,
        store: store)
    end
  end  
end
