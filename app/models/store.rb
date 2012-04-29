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

  def user
    
  end
  def user_permission
    
  end

  def approved?
    active == 2
  end

  def enabled?
    enabled == true
  end

  def disabled?
    enabled == false
  end

  def self.find_active_store(url)
    Store.where('url = ? AND active = ? AND enabled = ?', url, 2, true).first
  end

  def editable?(user)
    true if store_roles.find_by_user_id(user.id)
  end
  def self.create_store(params, user)
    s = Store.new(params)
    Resque.enqueue(NewStoreEmailer, user.email)
    s.users << user
    s
  end

  def approve
    self.active = 2
    self.enabled = true
    self.save
  end

  def decline
    self.active = 0
    self.enabled = false
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

  def add_admin(email)
    u = User.find_by_email(email)
    if u
      users << u
      self.save
      Notification.new_store_admin(u, self).deliver
    else
      # Guest ignores certain crudentials
      #users << User.create(:email => email, :guest => true)
      Notification.new_user_and_store_admin(email, self).deliver
    end
  end
end
