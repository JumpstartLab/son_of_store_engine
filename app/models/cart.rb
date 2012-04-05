class Cart < ActiveRecord::Base
  attr_accessible :cart_items, :user, :products
  has_many :cart_items
  has_many :products, :through => :cart_items
  has_one :user

  def add_item(product)
    cart_items << CartItem.new(:product => product)
  end
end
# == Schema Information
#
# Table name: carts
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#