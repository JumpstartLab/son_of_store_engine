class Product < ActiveRecord::Base
  attr_accessible :description, :price, :title
  belongs_to :category
end
