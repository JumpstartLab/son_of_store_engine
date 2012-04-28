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
    product_sort(:revenue)
  end

  def revenue
    revenue = counter(:price)
  end

  def sales
    sales = counter(:quantity)
  end

  def self.product_sort(param)
    Product.active.sort do |prod_a, prod_b|
      prod_a.send(param) <=> prod_b.send(param)
    end.last
  end

  def counter(param)
    order_items.inject(0) { |sum, oi| sum + oi.send(param) }
  end

  def self.top_selling
    product_sort(:sales)
  end

  def self.active
    Product.where(:activity => true)
  end

  def status?
    activity
  end
end