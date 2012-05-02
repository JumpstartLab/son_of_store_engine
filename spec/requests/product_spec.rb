require 'spec_helper'

describe "Viewing products" do
  let!(:store) { Store.first }
  let!(:category) { FactoryGirl.create(:category, :store_id => store.id) }
  let!(:product) { FactoryGirl.create(:product, store_id: store.id) } 
  let!(:product_category)do
    p = ProductCategory.new
    p.update_attribute(:product, product)
    p.update_attribute(:category, category)
  end
  let!(:user) { FactoryGirl.create(:user, admin: true) }
  before(:each) do
    set_host("#{store.url_name}")
    visit "/sessions/new"
    fill_in "email", with: user.email
    fill_in "password", with: "foobar"
    click_link_or_button('Log in')
    visit products_path
  end

  context "and I'm not logged in" do
    context "and I visit the products index page" do

      it "lets me view the products index" do
        page.should have_content('Browse')
      end

      context "and a category has been created" do

        it "lists the category on the product index" do
          page.should have_content(category.name)
        end

        context "and assigned to the created product" do
          before(:each) { product.add_category_by_id(category.id) }

          context "and I visit a listed product's page" do
            before(:each) { visit product_path(product) }

            it "lets me view the products details" do
              page.should have_content(product.name)
            end

            it "does not contain admin options on the page" do
              page.should_not have_content('Retire this product')
            end

            it "displays the categories assigned to the product" do
              page.should have_content(category.name)
            end

          end

          context "and I visit the category's path" do
            before(:each) { visit category_path(category) }

            it "lists the products assigned to the category" do
              page.should have_content(product.name)
            end
          end
        end
      end
    end
  end

  context "and I log in as a non-admin" do

    context "and I visit the products index page" do
      before(:each) { visit products_path }

      it "lets me view the products index" do
        page.should have_content('Browse')
      end

      context "and a category has been created" do
        let!(:category) { FactoryGirl.create(:category, :store_id => store.id) }
        before(:each) { visit products_path }

        it "lists the category on the product index" do
          page.should have_content(category.name)
        end

        context "and assigned to the created product" do
          before(:each) { product.add_category_by_id(category.id) }

          context "and I visit a listed product's page" do
            before(:each) { visit product_path(product) }

            it "lets me view the products details" do
              page.should have_content(product.name)
            end

            it "does not contain admin options on the page" do
              page.should_not have_content('Retire this product')
            end

            it "displays the categories assigned to the product" do
              page.should have_content(category.name)
            end

          end

          context "and I visit the category's path" do
            before(:each) { visit category_path(category) }

            it "lists the products assigned to the category" do
              page.should have_content(product.name)
            end
          end
        end
      end
    end
  end

end
