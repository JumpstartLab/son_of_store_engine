require 'spec_helper'

describe Customer do
  let(:user){Fabricate(:user)}
  let(:customer) { Fabricate(:customer, user_id: user.id) }
  context "creation with payment" do
    it "be able to save with valid user" do
      customer.save_with_payment
    end

    it "finds that customer, given the user" do
      c = Customer.find_or_create_by_user(user)
      c.should_not == nil
    end
  end
end
# == Schema Information
#
# Table name: customers
#
#  id                    :integer         not null, primary key
#  stripe_token          :string(255)
#  user_id               :integer
#  ship_address          :string(255)
#  ship_address2         :string(255)
#  ship_state            :string(255)
#  ship_zipcode          :string(255)
#  ship_city             :string(255)
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#  stripe_customer_token :string(255)
#

