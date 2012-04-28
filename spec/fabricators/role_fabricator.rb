# == Schema Information
#
# Table name: roles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

Fabricator(:role) do
  name { Faker::Lorem.words(2).join(' ').underscore }
end
