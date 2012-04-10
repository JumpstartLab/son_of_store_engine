require 'spec_helper'

describe Order do
  let(:order) { Fabricate(:order) }
  let(:order_item1) { Fabricate(:order_item, :price => 10, :quantity => 2) }
  let(:order_item2) { Fabricate(:order_item, :price => 20, :quantity => 1) }

  before(:each) do
    order.stub(:order_items).and_return([order_item1, order_item2])
  end

  describe '#total' do
    it "should return the total cost of the order" do
      order.total.should == 40
    end
  end
  describe '#decimal_total' do
    it "should return a money object of the total/100" do
      order.stub(:total).and_return(123)
      order.decimal_total.should == Money.new(123)
    end
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

