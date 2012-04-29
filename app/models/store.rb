class Store < ActiveRecord::Base
  attr_accessible :description, :name, :url_name, :approved, :enabled, :owner_id

  has_many :products
  has_many :categories

  validates_presence_of :name, :url_name, :description
  validates_uniqueness_of :name, :url_name

  def to_param
    url_name
  end

  def disabled
    !self.enabled
  end

  # # def update_status(status)
  # #   case status
  # #   when ""

  # end
end
