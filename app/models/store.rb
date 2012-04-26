class Store < ActiveRecord::Base
  attr_accessible :active, :name, :enabled, :description, :users, :url

  validates_uniqueness_of :name, :url

  has_many :store_roles
  has_many :users, :through => :store_roles

  def status
    if active == false
      "pending"
    else
      "active"
    end
  end

  def self.find_active_store(url)
    Store.where('url = ? AND active = ? AND enabled = ?', url, true, true).first
  end

end
