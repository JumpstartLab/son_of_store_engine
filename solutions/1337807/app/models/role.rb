# == Schema Information
#
# Table name: roles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#



# CanCan uses roles to manage authorization
class Role < ActiveRecord::Base
  attr_accessible :name
  has_many :user_roles
  has_many :users, :through => :user_roles

  validates :name, :presence => true, :uniqueness => true

  def self.admin
    where('name = ?', 'admin').first || Role.create(:name => 'admin')
  end

  def self.super_admin
    where('name = ?', 'super_admin').first ||
      Role.create(:name => 'super_admin')
  end

  def self.stocker
    where('name = ?', 'stocker').first || Role.create(:name => 'stocker')
  end
end
