# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  username               :string(255)
#  role                   :string(255)
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#

Fabricator(:user) do
  name "Peter Griffin"
  email { Faker::Internet.email }
  username "peter"
  password "derpina"
end

# Fabricator(:unique_user) do
#   name "#{Faker::Name.first_name} #{Faker::Name.last_name}"
#   email Faker::Internet.email
#   username Faker::Internet.user_name
#   password Faker::Lorem.words(1).first
# end
