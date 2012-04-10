require 'spec_helper'

describe OrderItem do
  let(:order) { Fabricate(:order) }
  
  describe '#decimal_total' do
    it "should return a money object of the total/100" do
      order.stub(:total).and_return(123)
      order.decimal_total.should == Money.new(123)
    end
  end
end
# == Schema Information
#
# Table name: order_items
#
#  id         :integer         not null, primary key
#  order_id   :integer
#  product_id :integer
#  quantity   :integer
#  price      :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

