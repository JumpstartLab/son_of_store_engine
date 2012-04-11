require 'spec_helper'

describe Cart do  
  describe "#items" do
    context "when items have been added to the cart" do
      let(:cart){ Fabricate(:cart) }
      let(:cart2) { Fabricate(:cart, user_id: 2)}
      let(:products) {[Fabricate(:product, id: 1), Fabricate(:product, id: 2)]}
      let(:products2) {[Fabricate(:product, id: 3), Fabricate(:product, id: 4)]}

      before(:each) do
        products.each { |product| cart.add_product(product) }
      end

      it "adds the items to the cart" do
        cart.products.count.should == 2
      end

      it "clears the cart" do
        cart.clear
        cart.products.count.should == 0
      end

      it "can absorb ALL the things" do
        products2.each {|p| cart2.add_product(p) }
        cart.absorb(cart2)
        products2.each do |product|
          cart.products.should be_include(product)
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

