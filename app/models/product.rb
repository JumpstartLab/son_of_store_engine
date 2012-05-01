# == Schema Information
#
# Table name: products
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  price       :integer
#  photo       :string(255)
#  retired     :boolean         default(FALSE)
#  store_id    :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

# A product can be added to a cart or an order through order_items
class Product < ActiveRecord::Base
  self.per_page = 10

  attr_accessible :description, :price, :title, :photo, :retired
  has_many :order_items
  has_many :orders, :through => :order_items
  has_many :product_categories
  belongs_to :store
  has_many :categories, :through => :product_categories
  validates :title, :uniqueness => true,
            :presence => true
  validates :description, :presence => true
  validates :price, :presence => true

  after_save :default_photo

  def self.retired
    where(:retired => true)
  end

  def self.active
    where(:retired => false)
  end

  def self.by_store(store)
    where(:store_id => store.id)
  end

  def add_category(category)
    categories << category
  end

  def price=(val)
    self[:price] = (BigDecimal.new(val) * 100).round
  end

  def price
    (self[:price] * 0.01).round(2)
  end

  def retire
    self.retired = true
    save
  end

  def retired?
    self.retired
  end

  def default_photo
    update_attributes(:photo => DEFAULT_PHOTO) if photo.blank? || photo.nil?
  end
end
