class Product < ActiveRecord::Base
  attr_accessible :description, :price, :title, :image_url, :on_sale, :category_ids
  has_many :categories, :through => :category_products
  has_many :category_products
  has_many :order_items
  has_many :orders, :through => :order_items
  validates_presence_of :categories, :description, :title, :price
  validates :title, :length => { :minimum => 1 }
  validates :description, :length => { :minimum => 1 }
  validates_numericality_of :price, :greater_than => 0
  validates_uniqueness_of :title
  validates_format_of :image_url,
                      :with => %r{.(gif|jpg|png)$}i, :allow_blank => true

  validate :categories_valid?

  default_scope order(:title) #orders them by title

  def categories_valid?
    unless self.categories && self.categories.any?
      errors[:base] << "Please pick a category, homeslice."
    end
  end

  def decimal_price
    Money.new(price || 0)
  end

  def self.search(search_term)
    Product.where("title LIKE ? OR description LIKE ?", "%#{search_term}%", "%#{search_term}%")
  end

  def matches?(search_term)
    title.match "/.*#{search_term}.*/i"
  end
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

