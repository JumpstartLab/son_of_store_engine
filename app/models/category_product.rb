class CategoryProduct < ActiveRecord::Base
  attr_accessible :category_id, :product_id

  belongs_to :category
  belongs_to :product
end