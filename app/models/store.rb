class Store < ActiveRecord::Base
  attr_accessible :description, :name, :url_name, :approved, :enabled, :owner_id

  has_many :products
  has_many :categories

  has_many :store_admins
  has_many :users, :through => :store_admins
  alias_attribute :admins, :users

  validates_presence_of :name, :url_name, :description
  validates_uniqueness_of :name, :url_name

  after_create :create_store_admin

  def to_param
    url_name
  end

  def disabled
    !self.enabled
  end

  def pending?
    self.approved.nil?
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

  def add_admin(admin)
    self.admins ||= [ ]
    self.admins << admin unless self.admins.include? admin
    self.admins.uniq
  end
end
