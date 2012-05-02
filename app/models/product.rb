#
class Product < ActiveRecord::Base
  attr_accessible :title, :description, :price, :photo_url, :category_ids,
    :retired, :store_id
  has_many :product_categorizations
  has_many :categories, :through => :product_categorizations
  has_many :line_items
  belongs_to :store

  validates_presence_of :title, :description, :price
  validates_format_of :title, :description, with: /\w/
  validates_uniqueness_of :title
  validates_numericality_of :price
  validates_format_of :photo_url,
    with: /\Ahttp.*(jpeg|jpg|gif|png)\Z/,
  allow_nil: true, unless: Proc.new { |prod| prod.photo_url.blank? }

  default_scope order(:title)

  def self.by_category_id(category_id)
    joins(:categories).where(:category_id => category_id)
  end

  def self.active
    where(retired: false)
  end

  def to_param
    [id, title.downcase.split(" ")].join("-")
  end

  def retire
    update_attribute(:retired, true)
  end

  def make_active_again
    update_attribute(:retired, false)
  end

  def category_ids=(params)
    self.categories = []
    params.each do |id|
      unless id.to_s.empty?
        category = Category.find(id)
        categories << category
      end
      save
    end
  end

  def price
    cents = BigDecimal.new(read_attribute(:price).to_s)
    price = cents / 100
  end

  def price=(input)
    super if input.nil?
    if /^[\d\.,]{1,20}/.match input
      cents = BigDecimal.new(input.to_s, 2) * 100.0
      write_attribute(:price, cents)
    else
      super
    end
  end

  def image
    if !photo_url || photo_url == ""
      "/logo.png"
    else
      photo_url
    end
  end

  def status
    self.retired ? "retired" : "active"
  end

  def active?
    !retired
  end
end
# == Schema Information
#
# Table name: products
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :string(255)
#  price       :integer
#  photo_url   :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  retired     :boolean         default(FALSE)
#  store_id    :integer
#

