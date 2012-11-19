require 'spec_helper'

describe Product do
  let!(:admin_user) { Fabricate(:admin_user) }
  let!(:store) { Fabricate(:store, :users => [admin_user]) }
  let!(:products) do
    [
      Fabricate(:product, :store => store),
      Fabricate(:product, :store => store),
      Fabricate(:product, :store => store)
    ]
  end
  let(:product) { Fabricate(:product, :store => store) }
  let(:category) { Fabricate(:category, :store => store) }

  context "index" do
    before(:each) do
      visit products_path(store)
    end

    it "shows all of the product titles" do
      products.each do |product|
        page.should have_content(product.title)
      end
    end

    it "shows all of the product prices" do
      products.each do |product|
        page.should have_content(product.price)
      end
    end

    it "has links to show each product" do
      products.each do |product|
        find_link("#{product.title}")
      end
    end
  end

  context "show" do
    before(:each) do
      product.add_category(category)
      visit product_path(store, product)
    end

    it "adds a product to the cart when 'add to cart' is clicked" do
      click_link "Add to Cart"
      page.should have_content(product.title)
    end

    it "lists all the product's categories" do
      page.should have_content(category.name)
    end

    it "displays the default image for a product with a blank photo" do
      product.update_attributes(:photo => '')
      visit product_path(store, product)
      page.should have_xpath("//img[@src=\"#{DEFAULT_PHOTO}\"]")
    end

  end

  context "admin" do
    let!(:category) { Fabricate(:category, :store => store) }
    context "show" do
      before(:each) do
        login_as(admin_user)
        visit admin_product_path(store, product)
      end

      it "lists all of the categories to which a product can be assigned" do
        page.should have_content("Add Category to this Product")
      end

      it "allows for a product to be added to a category" do
        click_link("#{category.name}")
        category.products.should include(product)
      end

      it "allows the admin to retire the product" do
        page.should have_link("Retire Product")
      end

      it "retires the product when the 'retire' link is clicked" do
        click_link_or_button("Retire Product")
        page.should have_content("Product #{product.title} retired")
        visit products_path(store)
        page.should_not have_content(product.title)
      end
    end
  end
end
