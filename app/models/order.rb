class Order < ActiveRecord::Base
  attr_accessible :status, :user_id
  belongs_to :user
  has_many :order_items
  has_many :products, :through => :order_items

  def update_attributes(params)
    self.shipped = Time.now if params[:status] == "shipped" && status != "shipped"
    self.returned = Time.now if params[:status] == "returned" && status != "returned"
    super
  end

  def total
    order_items.each.inject(0) { |sum, item| sum + item.price*item.quantity}
  end

  def decimal_total
    Money.new(total)
  end
end
# == Schema Information
#
# Table name: orders
#
#  id         :integer         not null, primary key
#  status     :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

