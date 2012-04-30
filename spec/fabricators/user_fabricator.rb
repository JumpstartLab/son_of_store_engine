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
#

Fabricator(:user) do
  name 'Peter Griffin'
  email { Faker::Internet.email }
  username 'peter'
  password 'derpina'
end

Fabricator(:stocker_user, :from => :user) do
  name 'Meg Griffin'
  email { Faker::Internet.email }
  username 'meg'
  password 'derpina'
  after_build do |stocker_user|
    role = Fabricate(:role, :name => 'stocker')
    stocker_user.roles << role
  end
end

Fabricator(:admin_user, :from => :user) do
  name 'Lois Griffin'
  email { Faker::Internet.email }
  username 'lois'
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
