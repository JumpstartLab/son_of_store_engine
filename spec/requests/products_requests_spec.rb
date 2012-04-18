require 'spec_helper'

describe "Products Requests" do
  context "root" do
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

  context "index" do
    let!(:category) { Fabricate(:category) }
    let!(:filtered_products) { [Fabricate(:product), Fabricate(:product)] }
    let!(:products) { [Fabricate(:product), Fabricate(:product)]}
    let!(:removed_product) { Fabricate(:product, :on_sale => false) }
    before(:each) do
      Category.stub(:find_by_id).and_return(category)
      category.stub(:products).and_return(filtered_products)
    end

    context "a category id is passed in params" do
      it "returns only the products that are a part of that category" do
        visit products_path + "?category_id=1"
        filtered_products.each do |product|
          page.should have_link(product.title, :href => product_path(product))
        end
      end
    end

    context "no category id is passed in params" do
      it "returns all products" do
        visit products_path
        products.each do |product|
          page.should have_link(product.title, :href => product_path(product))
        end
      end
    end

    context "the product is not on sale" do
      it "does not appear on the index" do
        visit products_path
        page.should_not have_link(removed_product.title, :href => product_path(removed_product))
      end
    end
  end

  context "show" do
    let!(:product) { Fabricate(:product) }
    it "shows the product title and price" do
      visit product_path(product)
      page.should have_content(product.title)
      page.should have_content(product.price)
    end
  end

  # context "new" do
  #   it "should show a blank product form" do
  #     visit new_product_path
  #     page.should have_selector("input#product_title")
  #     within("input#product_title") do
  #       page.should have_content("")
  #     end
  #   end
  # end
end