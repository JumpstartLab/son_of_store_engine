class Store < ActiveRecord::Base
  attr_accessible :name, :slug, :description, :status

  validates :name, :presence => true,
                   :uniqueness => true
  validates :slug, :presence => true,
                   :uniqueness => true

  has_many :carts
  has_many :categories
  has_many :credit_cards
  has_many :orders, :extend => FindByStatusExtension
  has_many :products
  has_many :shipping_details
  has_many :store_users
  has_many :users, :through => :store_users

  def self.approved
    where(:status => "approved")
  end

  def self.pending 
    where(:status => "pending")
  end

end
