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
                  :remember_me,
                  :role

  has_one :address
  has_one :cart
  has_many :orders
  has_many :user_roles
  has_many :roles, :through => :user_roles
  has_many :store_users
  has_many :stores, :through => :store_users

  validates_presence_of :name, :email
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_uniqueness_of :email
  validates_length_of :username, :within => 2..32,
                      :too_long => "pick a shorter name",
                      :too_short => "pick a longer name",
                      :allow_blank => true

  after_create :send_welcome_email

  def admin?
    role == 'admin'
  end

  def super_admin?
    roles.map(&:name).include? 'super_admin'
  end

  def set_role(role)
    self.role = role
    save
    self
  end

  def add_role(role)
    roles << role
    save
  end

  def update_roles(role_ids)
    self.roles = []

    role_ids.each do |role_id|
      self.roles << Role.find(role_id)
    end
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver
  end
end
