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
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

# A product can be added to a cart or an order through order_items
class Product < ActiveRecord::Base
  attr_accessible :description, :price, :title, :photo, :retired
  has_many :order_items
  has_many :orders, :through => :order_items
  has_many :product_categories
  has_many :categories, :through => :product_categories
  validates :title, :uniqueness => true,
            :presence => true
  validates :description, :presence => true
  validates :price, :presence => true
  validates :photo,
            :allow_blank => true,
            :format => {
              :with => URI::regexp(%w(http https)),
              :message => "must be URL"
            }

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
end
