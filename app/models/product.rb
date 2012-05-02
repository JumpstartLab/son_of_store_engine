class Product < ActiveRecord::Base
  attr_accessible :title, :description, :activity,
                  :price, :image_link,
                  :category_ids, :categories

  validates_presence_of :title, :description
  validates_numericality_of :price, :greater_than => 0

  validates_uniqueness_of :title

  after_create :add_image_if_blank

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

  def revenue
    revenue = counter(:price)
  end

  def sales
    sales = counter(:quantity)
  end

  def counter(param)
    order_items.inject(0) { |sum, oi| sum + oi.send(param) }
  end

  def self.top_selling_for_store(store)
    if cached_value = Rails.cache.read("#{store.slug}_top_seller")
      Product.find(cached_value)
    elsif store.order_items.any?
      top_seller = find(store.order_items.count(group: "product_id").invert.max.last)
      Rails.cache.write("#{store.slug}_top_seller", top_seller.id)
      Product.find(Rails.cache.read("#{store.slug}_top_seller"))
    else
      store.products.first
    end
  end

  def self.active
    Product.where(:activity => true)
  end

  def status?
    activity
  end

  def add_image_if_blank
    if image_link.blank?
      update_attribute(:image_link, "http://t0.gstatic.com/images?q=tbn:ANd9GcTCuHKEZTTrdXLlLg27llqQX0xq2bQhhw5MtnPUeZBx1i6kAKBcKqGEFM4TBA")
    end
  end
end