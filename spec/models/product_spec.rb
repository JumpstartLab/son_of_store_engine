require 'spec_helper'

describe Product do
  let(:product){Fabricate(:product)}
  context "new" do
    it "should set on_sale to true" do
      product = Product.create
      product.on_sale.should == true
    end
  end
  context ".search" do
    it "finds the product" do
      p = Product.search(product.title)
      p.first.should === product
    end
  end
  
end
# == Schema Information
#
# Table name: products
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  price       :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  image_url   :string(255)
#  on_sale     :boolean
#

