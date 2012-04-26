#
class ProductCategorization < ActiveRecord::Base
  attr_accessible :category_id, :product_id
  belongs_to :product
  belongs_to :category
end
# == Schema Information
#
# Table name: product_categorizations
#
#  id          :integer         not null, primary key
#  product_id  :integer
#  category_id :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

