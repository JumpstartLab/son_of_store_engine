# == Schema Information
#
# Table name: stores
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  user_id    :integer
#  permalink  :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Store < ActiveRecord::Base
  attr_accessible :name, :user_id
  make_permalink :with => :name

  validates :name, :presence => true, :uniqueness => true

  has_many :products
  has_many :categories
  has_many :orders

  def active_products
    products.active
  end

  def retired_products
    products.retired
  end
end
