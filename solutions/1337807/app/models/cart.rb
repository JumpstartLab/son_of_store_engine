# == Schema Information
#
# Table name: orders
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  status     :string(255)
#  address_id :integer
#  store_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  email      :string(255)
#  slug       :string(255)
#

# A cart is an order with state, and becomes an order on checkout.
class Cart < Order
  def add_product_by_id(product_id)
    add_product(Product.find(product_id))
  end
end
