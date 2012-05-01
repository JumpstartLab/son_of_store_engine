#
class User < ActiveRecord::Base
  attr_accessible :email_address, :full_name, :display_name, :password
  attr_accessible :password_confirmation
  has_one :billing_method
  has_one :shipping_address
  has_many :orders
  has_many :store_permissions
  has_secure_password

  validates_presence_of :full_name, :email_address
  validates_format_of :email_address,
  :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/
  validates_uniqueness_of :email_address
  validates_length_of :display_name, :minimum => 2, :maximum => 32,
    allow_nil: true, unless: Proc.new { |user| user.display_name.blank? }

  def pending_order
    orders.find_by_status("pending")
  end

  def has_pending_order?
    pending_order ? true : false
  end

  def has_order?
    orders.any?
  end

  def billing_method_id
    billing_method.id
  end

  def has_billing_method?
    billing_method ? true : false
  end

  def shipping_address_id
    shipping_address.id
  end

  def has_shipping_address?
    shipping_address ? true : false
  end

  def send_welcome_email
    UserMailer.welcome_email(self.id).deliver
  end

  def is_admin_of(store)
    admin_user = "store_id = #{store.id} AND permission_level = 1"
    self.admin || store_permissions.where(admin_user).first
  end
end
# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  email_address   :string(255)
#  full_name       :string(255)
#  display_name    :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  admin           :boolean         default(FALSE)
#  admin_view      :boolean         default(FALSE)
#

