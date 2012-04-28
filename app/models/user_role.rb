# == Schema Information
#
# Table name: user_roles
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  role_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

# This defines the many to many relationship for users and roles.
class UserRole < ActiveRecord::Base
  attr_accessible :role_id, :user_id
  belongs_to :role
  belongs_to :user
end
