class Role < ActiveRecord::Base
  attr_accessible :name, :store, :user

  belongs_to :user
  belongs_to :store
end
