class Product < ActiveRecord::Base
  attr_accessible :description, :price, :title
  belongs_to :category
end
# == Schema Information
#
# Table name: products
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  price       :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  category_id :integer
#
  