FactoryGirl.define do
  factory :user do
    name                  "John Doe"
    email                 "john@example.com"
    display_name          "john_doe"
    password              "foobar"
    password_confirmation "foobar"

    after_create do |model, evaluator|
      # Sorcery seems to blank out these fields after saving.
      model.password = evaluator.password
      model.password_confirmation = evaluator.password_confirmation
    end
  end

  factory :store_admin, class: User do
    name                  "Matt Yoho"
    email                 "matt@example.com"
    display_name          "john_doe"
    password              "foobar"
    password_confirmation "foobar"
    admin                 true

    after_create do |model, evaluator|
      # Sorcery seems to blank out these fields after saving.
      model.password = evaluator.password
      model.password_confirmation = evaluator.password_confirmation
    end
  end

  factory :site_admin, class: User do
    name                  "Jeff Casimir"
    email                 "jeff@example.com"
    display_name          "john_doe"
    password              "foobar"
    password_confirmation "foobar"
    site_admin            true

    after_create do |model, evaluator|
      # Sorcery seems to blank out these fields after saving.
      model.password = evaluator.password
      model.password_confirmation = evaluator.password_confirmation
    end
  end
end
