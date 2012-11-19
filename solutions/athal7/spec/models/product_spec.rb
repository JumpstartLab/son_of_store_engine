require 'spec_helper'

describe Product do

  [:title, :description, :price].each do |attr|
    it "has an attribute #{attr}" do
      Product.new.should respond_to(attr)
    end
  end

  context "valid attributes" do
    let(:product) { Fabricate(:product) }

    context "presence of" do
      it "is valid with valid attributes and a nil photo url" do
        product.should be_valid
      end

      it "is not valid without a title" do
        product.title = nil
        product.should_not be_valid
      end

      it "is not valid without a description" do
        product.description = nil
        product.should_not be_valid
      end

    end

    context "type validations" do
      it "does not allow a duplicate title to be created" do
        first_product = {title: "a", description: "b", price: "5"}
        second_product = {title: "a", description: "c", price: "6"}
        Product.create(first_product)
        Product.create(second_product).should_not be_valid
      end

      it "is not valid with a non-numerical price" do
        product.price = "string"
        product.should_not be_valid
      end


      it "accepts a valid photo_url" do
        product.photo_url = "http://blah.com/blah.jpg"
        product.should be_valid
      end

      it "does not accept an invalid photo_url" do
        product.photo_url = "blah"
        product.should_not be_valid
      end
    end
  end
  describe "#category_ids=" do
    let(:first_cat) { Fabricate(:category) }
    let(:second_cat) { Fabricate(:category) }
    it "creates the category relationships for the product" do
      cat_ids = [first_cat.id, second_cat.id]
      Product.create({title: "a", description: "b", price: "6",
        category_ids: cat_ids}).should be_valid

      cat_ids.each do |id|
        Product.last.categories.should include Category.find(id)
      end
    end
  end

  describe "#image" do
    let(:product) {Fabricate(:product)}
    context "when there is a photo_url" do
      it "returns the photo_url" do
        image_address = "http://image.com/image.jpg"
        product.update_attribute(:photo_url, image_address)
        product.image.should == image_address
      end
    end
    context "when there is no photo_url" do
      it "returns the logo" do
        product.update_attribute(:photo_url, "")
        product.image.should == "icon.png"
      end
    end
  end
  describe "#to_param" do
    it "returns the dom_id of the product" do
      prod = Fabricate(:product)
      prod.to_param.should == "#{prod.id}-#{prod.title.downcase.gsub(" ","-")}"
    end
  end
  describe "#active?" do
    it "returns true if active and false if not" do
      prod = Fabricate(:product)
      prod.active?.should == true
      prod.update_attribute(:retired, true)
      prod.active?.should == false
    end
  end
end# == Schema Information
#
# Table name: products
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :string(255)
#  price       :integer
#  photo_url   :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  retired     :boolean         default(FALSE)
#  store_id    :integer
#

