class Store < ActiveRecord::Base
  has_many :products
  has_many :orders
  has_many :categories

  attr_accessible :name, :domain, :description, :approval_status
  validates :name, uniqueness: true
  validates :domain, uniqueness: true
  validates :creating_user_id, presence: true

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
    StoreMailer.approval_email(self).deliver
  end
  
  def email_decline
    StoreMailer.decline_email(self).deliver
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

