# == Schema Information
#
# Table name: stores
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  store_unique_id :string(255)
#  description     :string(255)
#  status          :string(255)     default("pending")
#  user_id         :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

# Represents a store that is owned by a particular user
class Store < ActiveRecord::Base
  attr_accessible :name, :user_id, :store_unique_id, :description, :status

  validates :name, :presence => true
  validates :store_unique_id, :presence => true
  validates :description, :presence => true

  validates_uniqueness_of :store_unique_id,
                          :case_sensitive => false,
                          :on => :create

  validates_uniqueness_of :name, :case_sensitive => false, :on => :create

  has_many :products
  has_many :categories
  has_many :orders
  belongs_to :user

  def pending?
    status == 'pending'
  end

  def active?
    status == 'active'
  end

  def self.pending
    where(:status => 'pending')
  end

  def self.active
    where(:status => 'active')
  end

  def active_products
    products.active
  end

  def retired_products
    products.retired
  end

  def to_param
    store_unique_id
  end
end
