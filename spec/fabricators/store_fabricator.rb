# == Schema Information
#
# Table name: stores
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  store_unique_id :string(255)
#  description     :string(255)
#  status          :string(255)     default("pending")
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

Fabricator(:store) do
  name Faker::Lorem.words(3).join(" ")
  description Faker::Lorem.words(10).join(" ")
  store_unique_id Faker::Lorem.words(1).first
  status 'active'
end
