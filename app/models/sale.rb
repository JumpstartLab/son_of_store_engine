# Stores a single product / a category that has a sale
class Sale < ActiveRecord::Base
  attr_accessible :categories, :end_at, :percent_off,
                  :products, :product_ids, :category_ids

  has_many :categories
  has_many :products

  validates_presence_of :percent_off, :end_at
  validates_numericality_of :percent_off, :in => 0..100

  default_scope where("end_at > ?", Time.now)

  def percent
    self.percent_off.to_f / 100
  end

  def display_percent
    "#{percent_off}%"
  end

end