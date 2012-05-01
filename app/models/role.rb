class Role < ActiveRecord::Base
  attr_accessible :name, :store, :user

  belongs_to :user
  belongs_to :store

  def user_name
    user.name
  end

  def store_name
    store.name
  end

end
