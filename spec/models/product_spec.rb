# == Schema Information
#
# Table name: products
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  price       :integer
#  photo       :string(255)
#  retired     :boolean         default(FALSE)
#  store_id    :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe Product do
  let!(:store) { Fabricate :store }
  let(:product) { Fabricate :product, :store => store }
  let(:retired_product) { Fabricate :product, :retired => true }

  it "can't be created with a blank title" do
    product.title = ""
    product.should_not be_valid
  end

  it "can't be created with a blank description" do
    product.description = ""
    product.should_not be_valid
  end

  it "creates with a 0 price if price is blank" do
    product.price = ""
    product.price.should == 0
  end

  it "must have a URL photo" do
    product.photo = "awesome"
    product.should_not be_valid
  end

  it "rounds correctly" do
    product.update_attributes(:price => "34.567")
    Product.find(product.id).price.to_s.should == "34.57"
  end

  it 'is retired' do
    Product.retired.first == retired_product
  end

  it 'by store' do
    Product.by_store(store).first == product
  end
end
