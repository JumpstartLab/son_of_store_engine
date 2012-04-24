class Product < ActiveRecord::Base
  attr_accessible :title, :description, :activity,
                  :price, :image_link,
                  :category_ids, :categories

  validates_presence_of :title, :description
  validates_numericality_of :price, :greater_than => 0

  validates_uniqueness_of :title

  belongs_to :store
  has_many :order_items
  has_many :product_categories
  has_many :categories, :through => :product_categories
  has_many :orders, through: :order_items

  def self.find_by(search_term)
    Product.where("upper(title) like ?", "%#{search_term.upcase}%") +
    Category.where("upper(title) like ?",
      search_term.upcase).map {|category| category.products}.flatten
  end

  def self.top_grossing
    Product.active.sort do |prod_a, prod_b|
      prod_a.revenue <=> prod_b.revenue
    end.last
  end

  def sales
    sales = order_items.inject(0) { |sum, oi| sum + oi.quantity }
  end

  def self.top_selling
    Product.active.sort do |prod_a, prod_b|
      prod_a.sales <=> prod_b.sales
    end.last
  end

  def self.active
    Product.where(:activity => true)
  end

  def revenue
    revenue = order_items.inject(0) { |sum, oi| sum + oi.price }
  end

  def status?
    activity
  end
end