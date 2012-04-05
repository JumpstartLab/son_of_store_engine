require 'spec_helper'

describe Cart do  
  describe "#items" do
    context "when items have been addded to the cart" do
      let(:cart){ Cart.new }
      let(:products) {[Fabricate(:product), Fabricate(:product)]}

      before(:each) do
        products.each do |product|
          @cart.add_product(product)
        end
        it "returns the items" do
          @cart.products.count == 2
        end
      end
    end
  end
end
# == Schema Information
#
# Table name: carts
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

