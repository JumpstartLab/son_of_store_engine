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

  def disabled?
    !enabled? 
  end

  def self.find_active_store(url)
    Store.where('url = ? AND active = ? AND enabled = ?', url, 2, true).first
  end

  def self.find_store(url)
    Store.where('url = ? AND active = ?', url, 2).first
  end

  def editable?(user)
    true if store_roles.find_by_user_id(user.id)
  end
  def self.create_store(params, user)
    s = Store.new(params)
    Resque.enqueue(NewStoreEmailer, user)
    s.users << user
    s
  end

  def approve
    self.active = 2
    self.enabled = true
    Notification.new_store_approval(self).deliver
    self.save
  end

  def decline
    self.active = 0
    self.enabled = false
    Notification.new_store_approval(self).deliver
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

  def add_stocker(email)
    u = User.find_by_email(email)
    if u
      sr = store_roles.new
      sr.user = u
      sr.permission = 5
      self.save
      Notification.new_store_stocker(u, self).deliver
    else
      Notification.new_user_and_store_stocker(email, self).deliver
    end      
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

  def remove_role(email)
    u = User.find_by_email(email)
    self.store_roles.find_by_user_id(u.id).destroy
    Notification.remove_role(u.email, self).deliver
  end
end
