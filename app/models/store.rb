class Store < ActiveRecord::Base
  attr_accessible :description, :name, :url_name

  has_many :products
  has_many :categories

  validates_presence_of :name, :url_name, :description
  validates_uniqueness_of :name, :url_name

  def to_param
    url_name
  end
end
