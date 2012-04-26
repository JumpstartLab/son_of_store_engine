class StoreUser < ActiveRecord::Base
  attr_accessible :store_id, :user_id

  belongs_to :store
  belongs_to :user
end
