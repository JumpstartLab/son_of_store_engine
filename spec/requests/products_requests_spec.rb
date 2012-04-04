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
  end

  context "show" do
    let!(:product) { Fabricate(:product) }
    it "shows the product title and price" do
      visit product_path(product)
      page.should have_content(product.title)
      page.should have_content(product.price)
    end
  end

  context "new" do
    it "should show a blank product form" do
      visit new_product_path
      page.should have_selector("input#product_title")
      within("input#product_title") do
        page.should have_content("")
      end
    end
  end

  context "edit" do
    let!(:product) { Fabricate(:product) }

    it "should show a product form pre-filled with product's info" do
      visit edit_product_path(product)
      page.should have_selector("input#product_title")
      save_and_open_page
      page.should have_selector("input", :value => product.title)
    end
  end
end