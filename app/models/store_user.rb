# == Schema Information
#
# Table name: store_users
#
#  id         :integer         not null, primary key
#  store_id   :integer
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

# Relational object that ties a user to a store and gives them admin access
class StoreUser < ActiveRecord::Base
  attr_accessible :store_id, :user_id

  belongs_to :store
  belongs_to :user
end
