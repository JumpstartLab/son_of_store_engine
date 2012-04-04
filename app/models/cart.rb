class Cart < ActiveRecord::Base
  attr_accessible :user_id
  has_many :cart_items
end
