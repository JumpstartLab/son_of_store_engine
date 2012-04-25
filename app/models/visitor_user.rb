class VisitorUser < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :orders
  has_many :addresses
end
