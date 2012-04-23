class CategoryProduct < ActiveRecord::Base
  attr_accessible :category_id, :product_id

  belongs_to :category
  belongs_to :product
end# == Schema Information
#
# Table name: category_products
#
#  id          :integer         not null, primary key
#  product_id  :integer
#  category_id :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

