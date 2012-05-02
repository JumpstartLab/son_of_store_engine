class Store < ActiveRecord::Base
  attr_accessible :active, :name, :enabled, :description, :users, :url, 
                  :photo_url

  validates_uniqueness_of :name, :url
  validates_presence_of :name, :url
  has_many :products
  has_many :store_roles
  has_many :products
  has_many :users, :through => :store_roles
  STATUS = ["Declined", "Pending", "Approved"]
  self.per_page = 15
  def status_name
    STATUS[active]
  end

  def declined?
    active == 0
  end

  def pending?
    active == 1
  end

  def user

  end
  def user_permission

  end

  def approved?
    active == 2
  end

  def disabled?
    !enabled?
  end

  def self.find_active_store(url)
    Store.where('url = ? AND active = ? AND enabled = ?', url, 2, true).first
  end

  def self.find_all_active_stores
    Store.where('active = ? AND enabled = ?', 2, true)
  end

  def self.find_store(url)
    Store.where('url = ? AND active = ?', url, 2).first
  end

  def editable?(user)
    true if store_roles.find_by_user_id(user.id)
  end

  def self.create_store(params, user)
    new_store = Store.new(params)
    new_store.users << user
    new_store
  end

  def approve
    self.active = 2
    self.enabled = true
    Resque.enqueue(NewStoreApprovalEmailer, self.id)
    self.save
  end

  def decline
    self.active = 0
    self.enabled = false
    Resque.enqueue(NewStoreApprovalEmailer, self.id)
    self.save
  end

  def enable
    self.enabled = true
    self.save
  end

  def disable
    self.enabled = false
    self.save
  end
end
