require 'spec_helper'

describe BillingMethod do
  let(:billing) { Fabricate(:billing_method) }
  describe ".find_by_order_id" do
    it "returns the billing method related to the order passed in" do
      order = Fabricate(:order)
      order.update_attribute(:billing_method_id, billing.id)
      BillingMethod.find_by_order_id(order.id).should == billing
    end
  end
  describe "#has_user?" do
    it "returns true if there is a user and false if not" do
      billing.has_user?.should == false
      user = Fabricate(:user)
      billing.update_attribute(:user_id, user)
      billing.has_user?.should == true
    end
  end
end
# == Schema Information
#
# Table name: billing_methods
#
#  id                 :integer         not null, primary key
#  credit_card_number :string(255)
#  street             :string(255)
#  city               :string(255)
#  state              :string(255)
#  zipcode            :string(255)
#  name               :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  user_id            :integer
#  card_type          :string(255)
#  month              :integer
#  year               :integer
#

