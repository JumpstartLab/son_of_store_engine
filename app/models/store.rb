class Store < ActiveRecord::Base
  attr_accessible :description, :name, :url_name, :approved, :enabled, :owner_id
  has_many :products
  has_many :categories

  has_many :store_admins
  has_many :users, :through => :store_admins

  validates_presence_of :name, :url_name, :description
  validates_uniqueness_of :name, :url_name

  after_create :create_store_admin, :store_creation_confirmation

  def to_param
    url_name
  end

  def store_creation_confirmation
    Resque.enqueue(Emailer, "store", "store_creation_confirmation", owner.id, self.id)
  end

  def stockers
    users.where("stocker = ?", true)
  end

  def admins
    users.where("stocker = ?", false)
  end

  def disabled
    !self.enabled
  end

  def pending?
    self.approved.nil?
  end

  def declined
    self.approved != true
  end

  def create_store_admin
    add_admin_by_id(self.owner_id)
  end

  def owner
    User.find(owner_id)
  end

  def add_admin_by_id(id)
    admin_user = User.find(id)
    add_admin(admin_user)
  end

  def add_stocker(stocker)
    store_admins.create(user_id: stocker.id, stocker: true)
  end

  def add_admin(admin)
    store_admins.create(user_id: admin.id, stocker: false)
  end
end
