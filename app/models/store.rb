class Store < ActiveRecord::Base
  attr_accessible :name, :slug, :owner_id, :description, :status

  has_many :products
  has_many :privileges
  has_many :carts
  has_many :orders
  has_many :categories

  validates_presence_of :slug
  validates_presence_of :name
  validates_presence_of :owner_id
  validates_uniqueness_of :name
  validates_uniqueness_of :slug

  def to_param
    slug
  end

  def owner
    User.find(owner_id)
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
    UserMailer.approved_store_notice(self).deliver
  end

  def enable!
    update_attribute(:status, "enabled")
  end

  def disable!
    update_attribute(:status, "disabled")
  end

  def decline!
    UserMailer.declined_store_notice(self).deliver
    self.destroy
  end

end
