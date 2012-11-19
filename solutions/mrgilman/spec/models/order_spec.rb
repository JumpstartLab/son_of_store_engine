require 'spec_helper'

describe Order do
  let!(:ord) { Fabricate(:order) }
  describe "#user" do
    it "returns the user associated with the order" do
      fake_user = Fabricate(:user)
      ord.user_id = fake_user.id
      ord.user.should == fake_user
    end
  end
  describe "#amount" do
    it "returns the total of the order" do
      actual_total = 0
      li = {}
      3.times do |t|
        li[t] = Fabricate(:line_item)
        li[t].update_attribute(:order_id, ord.id)
        actual_total += li[t].subtotal
      end
      ord.amount.should == actual_total
    end
  end

  describe "#next_transition" do
    it "returns the proper next status" do
      ord.update_attributes(status: "pending")
      ord.next_transition.should == "paid"
      ord.update_attributes(status: "paid")
      ord.next_transition.should == "shipped"
    end
  end

  describe "#user_name" do
    it "returns the display name of the order's user" do
      fake_user = Fabricate(:user)
      ord.user_id = fake_user.id
      ord.user_name.should == fake_user.display_name
    end
  end

  describe "#user_email_address" do
    it "returns the email address of the order's user" do
      fake_user = Fabricate(:user)
      ord.user_id = fake_user.id
      ord.user_email_address.should == fake_user.email_address
    end
  end

  describe "#has_product?" do
    it "returns a boolean of whether the order has a product" do
      prod = Fabricate(:product)
      ord.has_product?(prod.id).should == false
      LineItem.create(order_id: ord.id, product_id: prod.id)
      ord.has_product?(prod.id).should == true
    end
  end
  describe "#try_to_add_billing_and_shipping" do
    it "adds a billing method to the order if the user has one" do
      user = Fabricate(:user)
      billing = Fabricate(:billing_method)
      billing.update_attribute(:user_id, user.id)
      ord.stub(user: user)
      ord.try_to_add_billing_and_shipping(user.id)
      ord.find_billing.should == billing
    end
    it "adds a shipping address to the order if the user has one" do
      user = Fabricate(:user)
      shipping = Fabricate(:shipping_address)
      shipping.update_attribute(:user_id, user.id)
      ord.stub(user: user)
      ord.try_to_add_billing_and_shipping(user.id)
      ord.find_shipping.should == shipping
    end
  end
  describe "#set_action_time" do
    it "sets the action time for an object if cancelled or shipped" do
      ord.set_action_time("cancelled")
      ord.action_time.to_date.should == Time.now.to_date
    end
  end
  describe '#create_special_url' do
    it "sets a random url to the order" do
      old_url = ord.special_url
      ord.send(:create_special_url)
      ord.special_url.should_not == old_url
    end
    it "sets a special order on creation" do
      new_order = Fabricate(:order)
      new_order.special_url.should_not be_nil
    end
    it "sets unique special order urls" do
      orders = []
      10.times do |i|
        ord = Fabricate(:order)
        orders[i] = ord.special_url
      end
      orders.uniq.should == orders
    end
  end
end
# == Schema Information
#
# Table name: orders
#
#  id                  :integer         not null, primary key
#  user_id             :integer
#  billing_method_id   :integer
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  status              :string(255)     default("pending")
#  shipping_address_id :integer
#  action_time         :string(255)
#  store_id            :integer
#  special_url         :string(255)
#

