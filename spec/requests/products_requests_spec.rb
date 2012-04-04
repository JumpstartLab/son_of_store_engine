require 'spec_helper'

describe "Products Requests" do
  describe "root" do
    let!(:products) { [Fabricate(:product), Fabricate(:product)] }

    before(:each) do
      visit "/"
    end

    it "links to products" do
      products.each do |product|
        page.should have_link(product.title, :href => product_path(product))
      end
    end
  end
end