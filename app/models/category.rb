#
class Category < ActiveRecord::Base
  attr_accessible :name, :store_id

  has_many :product_categorizations
  has_many :products, :through => :product_categorizations
  belongs_to :store
  
  validates_presence_of :name

  def to_param
    [id, name.downcase.split(" ")].join("-")
  end

  def image
    if !products.empty?
      products.first.image
    else
      "icon.png"
    end
  end
end
