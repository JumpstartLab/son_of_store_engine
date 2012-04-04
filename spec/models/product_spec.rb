require 'spec_helper'

describe Product do
  context "new" do
    it "should set on_sale to true" do
      product = Product.create
      product.on_sale.should == true
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

