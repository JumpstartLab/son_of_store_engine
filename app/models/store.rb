class Store < ActiveRecord::Base
  attr_accessible :name, :slug, :owner_id, :description, :status

  has_many :products
  has_many :privileges
  has_many :carts
  has_many :orders
  has_many :categories
  has_many :employees, through: :privileges, source: "user"
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"

  validates :slug,  :presence   => true,
                    :uniqueness => { :case_sensitive => false }
  validates :name,  :presence   => true,
                    :uniqueness => { :case_sensitive => false }
  validates_presence_of :owner_id

  before_validation :strip_whitespace

  def to_param
    slug
  end

  def set_privilege(user, level)
    privileges.where(user_id: user.id).destroy_all
    privileges.create(user_id: user.id, name: level) if level
  end

  def privilege_for(user)
    privileges.find_by_user_id(user.id)
  end

  def enabled?
    status == "enabled"
  end

  def disabled?
    status == "disabled"
  end

  def pending?
    status == "pending"
  end

  def approve!
    update_attribute(:status, "enabled")
    BackgroundJob.store_approved_email(self)
  end

  def enable!
    update_attribute(:status, "enabled")
  end

  def disable!
    update_attribute(:status, "disabled")
  end

  def decline!
    BackgroundJob.store_declined_email(self)
    self.destroy
  end

  def order_items
    OrderItem.includes(:order).where("orders.store_id = ?", self.id)
  end

  def count_managers
    employees.select {|e| e.store_role(self) == "manager"}.size
  end

  def count_stockers
    employees.select {|e| e.store_role(self) == "stocker"}.size
  end

  private 

  def strip_whitespace
    self.name.strip!
    self.slug.strip!
  end
end
