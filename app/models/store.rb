# == Schema Information
#
# Table name: stores
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  slug        :string(255)
#  description :string(255)
#  status      :string(255)     default("pending")
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#



# Represents a store that is owned by a particular user
class Store < ActiveRecord::Base
  attr_accessible :name, :user_id, :slug, :description, :status
  before_validation :parameterize_slug

  validates :name, :presence => true
  validates :slug, :presence => true
  validates :description, :presence => true

  validates_uniqueness_of :slug,
                          :case_sensitive => false

  validates_uniqueness_of :name, :case_sensitive => false

  has_many :products
  has_many :categories
  has_many :orders
  has_many :store_users
  has_many :users, :through => :store_users

  def pending?
    status == 'pending'
  end

  def declined?
    status == 'declined'
  end

  def disabled?
    status == 'disabled'
  end

  def active?
    status == 'active'
  end

  def self.pending
    where(:status => 'pending')
  end

  def set_status!(s)
    self.status = s
    self.save()
  end

  def self.active
    where(:status => 'active')
  end

  def self.not_declined
    where("status != 'declined'")
  end

  def active_products
    products.active
  end

  def retired_products
    products.retired
  end

  def to_param
    slug
  end

  def self.find_by_slug(id)
    where(:slug => id.parameterize) unless id.blank?
  end

  def admin_users
    self.users.select { |user| user.admin? }
  end

  def stocker_users
    self.users.select { |user| user.stocker? }
  end

  def add_admin(user)
    user.add_role(Role.admin)
    self.users << user
  end

  def add_stocker(user)
    user.add_role(Role.stocker)
    self.users << user
  end

  def add_admin_from_form(email)
    if user = User.find_by_email(email)
      add_admin(user)
      StoreAdminMailer.new_admin_email(user, self).deliver
    end
  end

  def add_stocker_from_form(email)
    if user = User.find_by_email(email)
      add_stocker(user)
      StoreStockerMailer.new_stocker_email(user, self).deliver
    end
  end

  def invite_new_admin(email)
    StoreAdminMailer.invite_admin_email(email, self).deliver
  end

  def invite_new_stocker(email)
    StoreStockerMailer.invite_stocker_email(email, self).deliver
  end

  def delete_admin_user(user_id)
    user = User.find(user_id)
    if admin_users.length > 1
      StoreUser.find_by_user_id(user.id).destroy
      StoreAdminMailer.delete_admin_email(user, self).deliver
      true
    else
      false
    end
  end

  def delete_stocker_user(user_id)
    user = User.find(user_id)
    StoreUser.find_by_user_id(user.id).destroy
    StoreStockerMailer.delete_stocker_email(user, self).deliver
  end

  private

  def parameterize_slug
    unless self.slug.blank?
      self.slug = self.slug.parameterize
    end
  end
end
