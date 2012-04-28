class VisitorUser < ActiveRecord::Base
  attr_accessible :email
  
  has_many :orders
  has_many :addresses
end
