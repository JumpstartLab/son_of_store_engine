class Role < ActiveRecord::Base
  attr_accessible :role, :store, :user

  belongs_to :user
  belongs_to :store
end
