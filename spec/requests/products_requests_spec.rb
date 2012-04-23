require 'spec_helper'

describe "Products Requests" do
  let!(:admin_user) { Fabricate(:auth_user, :id => 1) }
  let!(:customer) { Fabricate(:customer, :user_id => 1) }
  let!(:product) { Fabricate(:product) }
  before(:each) do
    visit login_path
    fill_in('Email', :with => admin_user.email)
    fill_in('Password', :with => "admin")
    click_button('Log in')
  end

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

  context "one click" do
    it "impulse buys!" do
      OrdersController.any_instance.stub(:current_user).and_return(admin_user)
      visit product_path(product)
      page.find(:css, "#one-click").click
    end
  end

  context "show" do
    let!(:product) { Fabricate(:product) }
    it "shows the product title and price" do
      visit product_path(product)
      page.should have_content(product.title)
      page.should have_content(product.decimal_price)
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

    it "should show a product form pre-filled with product's info" do
      visit edit_product_path(product)
      page.should have_selector("input#product_title")
      page.should have_selector("input", :value => product.title)
    end
  end

  context "update" do
    let!(:product) { Fabricate(:product) }
    let!(:category) { Fabricate(:category) }
    before(:each) do
      visit edit_product_path(product)
    end
    context "valid params are passed" do
      it "updates the product" do
        fill_in('product_price', :with => 225)
        check(category.name)
        click_button("Update Product")
        Product.find_by_id(1).price.should == 225
      end
    end
    context "invalid params are passed" do
      it "does not update the product" do
        fill_in('product_price', :with => -2)
        check(category.name)
        click_button('Update Product')
        Product.find_by_id(1).price.should_not == -2
      end
    end
  end

  context "destroy" do
    let!(:product) { Fabricate(:product) }
    it "removes the product from the database" do
      product_count = Product.all.count
      ProductsController.any_instance.stub(:current_user).and_return(admin_user)
      visit product_path(product)
      click_link('Delete')
      Product.all.count.should == product_count - 1
    end
  end

  context "create" do
    let!(:category) { Fabricate(:category) }
    before(:each) do
      visit new_product_path
    end
    context "the params are valid for the product" do
      it "creates a new product" do
        product_count = Product.all.count
        fill_in('product_title', :with => 'Title')
        fill_in('product_description', :with => 'Description')
        fill_in('product_price', :with => 123)
        check(category.name)
        click_button(:submit)
        Product.all.count.should == product_count + 1
      end
    end
    context "the params are not valid" do
      it "does not create a new product" do
        product_count = Product.all.count
        fill_in('product_title', :with => 'Title')
        fill_in('product_description', :with => 'Description')
        check(category.name)
        click_button(:submit)
        Product.all.count.should == product_count
      end
    end
  end
end