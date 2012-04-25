class Store < ActiveRecord::Base
  has_many :products
  has_many :orders
  has_many :categories

  attr_accessible :name, :domain, :description
  validates :name, :uniqueness => true
  validates :domain, :uniqueness => true

  def to_param
    domain
  end
end
