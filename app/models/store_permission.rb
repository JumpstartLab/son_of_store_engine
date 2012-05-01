class StorePermission < ActiveRecord::Base
  attr_accessible :store_id, :user_id, :permission_level

  validates :store_id, numericality: true, presence: true
  validates :user_id, numericality: true, presence: true
  validates :permission_level, numericality: true, presence: true

  belongs_to :user
  belongs_to :store

  PERMISSION_TYPES = { 1 => "ADMIN", 2 => "STOCKER" }

  attr_reader :email

end

# == Schema Information
#
# Table name: store_permissions
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  store_id         :integer
#  permission_level :integer
#

