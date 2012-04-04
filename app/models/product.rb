class Product < ActiveRecord::Base
  attr_accessible :description, :price, :title, :image_url, :on_sale
  has_many :categories, :through => :category_products
  has_many :category_products

  # def initialize
  #   self.on_sale = true
  # end
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
#  image_url   :string(255)
#  on_sale     :boolean
#

