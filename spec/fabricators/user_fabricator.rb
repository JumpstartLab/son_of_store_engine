# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  username               :string(255)
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
#  authentication_token   :string(255)
#

Fabricator(:user) do
  name { Faker::Name.name }
  email { Faker::Internet.email }
  username { Faker::Name.name }
  password 'derpina'
end

Fabricator(:admin_user, :from => :user) do
  name { Faker::Name.name }
  email { Faker::Internet.email }
  username { Faker::Name.name }
  password 'derpina'
  after_build do |admin_user|
    role = Fabricate(:role, :name => 'admin')
    admin_user.roles << role
  end
end

Fabricator(:super_admin_user, :from => :user) do
  name 'Stewie Griffin'
  email { Faker::Internet.email }
  username 'stewie'
  password 'derpina'
  after_build do |super_admin_user|
    role = Fabricate(:role, :name => 'super_admin')
    super_admin_user.roles << role
  end
end
