require 'spec_helper'


describe ProductsController do
  render_views

  describe "GET 'index'" do

    let(:category1) { Fabricate(:category, :id => 1)}
    let(:product1) { Fabricate(:product, :category_id => 1)}
    let(:product2) { Fabricate(:product, :category_id => 2)}

    before(:each) do
      Product.stub(:all).and_return([product1, product2])
      Category.stub(:find_by_id).with(1).and_return(:cateogory1)
      category1.stub(:products).and_return([product1])
    end

    context "a category id is passed" do
    end
    context "no category id is passed" do
      it "returns all products" do

        visit products_path
        page.should have_link("#{product1.title}")
      end
    end
  end
  describe "GET 'show'" do
  end
end
