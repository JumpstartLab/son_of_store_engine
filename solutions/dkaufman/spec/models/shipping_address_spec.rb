require 'spec_helper'

describe ShippingAddress do
  describe ".find_by_order_id" do
    it "returns the shipping address related to the order passed in" do
      shipping = Fabricate(:shipping_address)
      order = Fabricate(:order)
      order.update_attribute(:shipping_address_id, shipping.id)
      ShippingAddress.find_by_order_id(order.id).should == shipping
    end
  end
end
# == Schema Information
#
# Table name: shipping_addresses
#
#  id            :integer         not null, primary key
#  street        :string(255)
#  state         :string(255)
#  zipcode       :string(255)
#  city          :string(255)
#  name          :string(255)
#  email_address :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  user_id       :integer
#

