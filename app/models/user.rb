class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :email, :password, :name

  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
end
# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  email      :string(255)
#  password   :string(255)
#  name       :string(255)
#  is_admin   :boolean
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

