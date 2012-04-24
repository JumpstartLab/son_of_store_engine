# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  username               :string(255)
#  role                   :string(255)
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#

# A user is an authenticated visitor
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email,
                  :username,
                  :name,
                  :password,
                  :password_confirmation,
                  :remember_me

  has_one :cart
  has_one :address
  has_many :orders

  validates_presence_of :name, :email
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_uniqueness_of :email
  validates_length_of :username, :within => 2..32,
                      :too_long => "pick a shorter name",
                      :too_short => "pick a longer name",
                      :allow_nil => true

  after_create :send_welcome_email

  def admin?
    role == 'admin'
  end

  def set_role(role)
    self.role = role
    save
    self
  end

  def add_credit_card(cc)
    cc[:user_id] = id
    CreditCard.create(cc)
  end

  def add_address(address)
    address[:user_id] = id
    Address.create(address)
  end

  def finalize_order(billing_information)
    add_credit_card(billing_information[:credit_card])
    add_address(billing_information[:address])

    order = Order.find(billing_information[:billing][:order_id])
    order.set_status('paid')
    order
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver
  end
end
