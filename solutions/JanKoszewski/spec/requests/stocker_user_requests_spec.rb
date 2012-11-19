require 'spec_helper'

describe User do
  let!(:store) { Fabricate(:store) }
  let!(:user) { Fabricate(:user) }
  let!(:products) {
    10.times.map do
      Fabricate(:product, :store => store)
    end
  }

  before(:each) do
    store.add_stocker(user)
    login_as(user)
  end

  context "with role stocker can" do
    it "view a store's products at the stocker url" do
      visit stock_products_path(store)

      products.each do |product|
        page.should have_content(product.title)
      end
    end

    it "create products" do
      visit stock_products_path(store)
      click_on 'New Product'

      fill_in 'Title', :with => 'Product A'
      fill_in 'Description', :with => 'Product Description'
      fill_in 'Price', :with => '1.00'
      click_button 'Create Product'
      page.should have_content('Product A')
    end

    context "edit products" do
      before(:each) do
        visit stock_products_path(store)
      end

      it "for the associated store" do
        click_on 'Edit'
        fill_in 'Title', :with => 'Product B'
        click_on 'Update Product'
        page.should have_content('Product B')
      end

      it "and after editing view a list of products with a confirmation" do
        click_on 'Edit'
        fill_in 'Title', :with => 'Product B'
        click_on 'Update Product'
        page.should have_content('Product updated')
      end
    end

    context "retire products" do
      it "for the associated store" do
        visit stock_products_path(store)
        click_on 'Retire'
        page.should have_content("Retired")
      end

      it "and after retiring view a list of products with a confirmation" do
        visit stock_products_path(store)
        click_on 'Retire'
        page.should have_content("retired")
      end
    end
  end
end
