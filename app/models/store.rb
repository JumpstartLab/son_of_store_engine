class Store < ActiveRecord::Base
  STATUSES = %w{ approved pending declined disabled }

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
  # has_many :store_users
  # has_many :users, :through => :store_users

  has_many :roles
  has_many :users, :through => :roles

  STATUSES.each do |status|
    define_method(status+"!") do
      self.status = status
    end

    define_method(status+"?") do
      self.status == status
    end

    scope status.to_sym, where(:status => status)
  end

  def active_products
    Product.where(:store_id => id).where(:retired => false)
  end

  def retired_products
    Product.where(:store_id => id).where(:retired => true)
  end

end
