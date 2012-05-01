class Store < ActiveRecord::Base
  has_many :products
  has_many :orders
  has_many :categories
  has_many :store_permissions

  attr_accessible :name, :domain, :description, :approval_status, :enabled
  validates :name, uniqueness: true
  validates :domain, uniqueness: true
  validates :creating_user_id, presence: true

  after_create :make_owner_an_admin

  def to_param
    domain
  end

  # will have store image eventually
  def image
    "icon.png"
  end

  def active_status
    enabled ? "Enabled" : "Disabled"
  end

  def owner
    User.find_by_id(creating_user_id)
  end

  def email_approval
    StoreMailer.approval_email(self.id).deliver
  end

  def email_decline
    StoreMailer.decline_email(self.id).deliver
  end

  def created_on
    created_at.strftime("%B %d at %l:%M %p")
  end

  def make_owner_an_admin
    StorePermission.create(user_id: creating_user_id, store_id: self.id,
                           permission_level: 1)
  end

  def approved?
    approval_status == "approved"
  end
end
# == Schema Information
#
# Table name: stores
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  approval_status  :string(255)     default("pending")
#  domain           :string(255)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  enabled          :boolean         default(FALSE)
#  description      :text
#  creating_user_id :integer
#

