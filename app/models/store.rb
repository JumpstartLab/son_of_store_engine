class Store < ActiveRecord::Base
  attr_accessible :description, :name, :url_name, :approved, :enabled, :owner_id

  has_many :products
  has_many :categories

  has_many :store_admins
  has_many :users, :through => :store_admins
  alias_attribute :admins, :users

  validates_presence_of :name, :url_name, :description
  validates_uniqueness_of :name, :url_name

  def to_param
    url_name
  end

  def disabled
    !self.enabled
  end

  def pending?
    self.approved.nil?
  end
end
