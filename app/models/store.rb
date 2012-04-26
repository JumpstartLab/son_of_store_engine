class Store < ActiveRecord::Base
  attr_accessible :active, :name, :enabled, :description, :users, :url

  validates_uniqueness_of :name, :url
  validates_presence_of :name, :url

  has_many :store_roles
  has_many :users, :through => :store_roles
  STATUS = ["Declined", "Pending", "Approved"]

  def status_name
    STATUS[active]
  end

  def declined?
    active == 0
  end
  def pending?
    active == 1
  end
  def approved?
    active == 2
  end

  def self.find_active_store(url)
    Store.where('url = ? AND active = ? AND enabled = ?', url, 2, true).first
  end

  def editable?(user)
    true if store_roles.find_by_user_id(user.id)
  end
  def self.create_store(params, user)
    s = Store.new(params)
    s.users << user
    s
  end
end
