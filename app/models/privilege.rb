class Privilege < ActiveRecord::Base
  attr_accessible :name, :store_id, :user_id

  belongs_to :user
  belongs_to :store
end
