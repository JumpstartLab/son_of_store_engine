class Order < ActiveRecord::Base
  attr_accessible :status, :user_id
  belongs_to :user
  has_many :order_items
  has_many :products, :through => :order_items
end
# == Schema Information
#
# Table name: orders
#
#  id         :integer         not null, primary key
#  status     :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

