class StoreAdmin < ActiveRecord::Base
  attr_accessible :user_id, :store_id

  belongs_to :user
  belongs_to :store
end