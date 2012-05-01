include HexHelper

class StorePermission < ActiveRecord::Base
  attr_accessible :store_id, :user_id, :permission_level, :admin_hex

  validates :store_id, numericality: true, presence: true
  validates :user_id, numericality: true, allow_blank: true
  validates :permission_level, numericality: true, presence: true

  belongs_to :user
  belongs_to :store

  PERMISSION_TYPES = { 1 => "ADMIN", 2 => "STOCKER" }

  def self.invite_user_to_be_admin_of(store, email)
    permission = StorePermission.create(store_id: store.id, admin_hex: create_hex, permission_level: 1)
    UserMailer.invite_admin_email(permission, email)
  end
end

# == Schema Information
#
# Table name: store_permissions
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  store_id         :integer
#  permission_level :integer
#  admin_hex        :string(255)
#

