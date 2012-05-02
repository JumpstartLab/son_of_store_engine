# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  username               :string(255)
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
#  authentication_token   :string(255)
#

# A user is an authenticated visitor
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  attr_accessible :email,
                  :username,
                  :name,
                  :password,
                  :password_confirmation,
                  :remember_me

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
  def admin?
    roles.include? Role.admin
  end

  def super_admin?
    roles.include? Role.super_admin
  end

  def stocker?
    roles.include? Role.stocker
  end

  def add_role(role)
    roles << role
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

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] &&
        session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = self.find_by_email(data.email)
      user
    else # Create a user with a stub password.
      self.create!(:email => data.email,
        :password => Devise.friendly_token[0,20],
        :name => data.name)
    end
  end
end
