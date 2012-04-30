FactoryGirl.define do

  factory :user do
    ignore do
      first_name { Faker::Name.first_name }
      last_name  { Faker::Name.last_name  }
    end

    name                  { first_name + " " + last_name }
    email                 { "#{first_name}_#{last_name}@gmail.com".downcase }
    display_name          { (first_name + "_" + last_name).downcase }
    password              "foobar"
    password_confirmation "foobar"

    after_create do |model, evaluator|
      # Sorcery seems to blank out these fields after saving.
      model.password = evaluator.password
      model.password_confirmation = evaluator.password_confirmation
    end
  end

  factory :site_admin, parent: :user do
    after_create do |model, evaluator|
      Role.create(user: model, name: "site_admin")
    end
  end

  factory :store_admin, parent: :user do
    ignore do
      store { FactoryGirl.create(:store) }
    end

    after_create do |model, evaluator|
      Role.create(user: model, name: "store_admin", store: evaluator.store)
    end
  end  
end