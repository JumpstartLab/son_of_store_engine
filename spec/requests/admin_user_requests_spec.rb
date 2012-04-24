require 'spec_helper'

describe User, :user_request => :user do
  let (:user) { Fabricate(:user) }
  let (:product) { Fabricate(:product) }
  let (:cart) { Fabricate(:cart) }

  after(:all) do
    User.destroy_all
  end

  context "with role admin can" do
    let(:address) { Fabricate(:address) }
    let!(:category) { Fabricate(:category) }
    let!(:product) { Fabricate(:product) }
    let!(:order) {
      Fabricate(
        :order,
        :user_id => user.id,
        :address_id => address.id
      )
    }

    before(:each) do
      user.set_role('admin')
      login_as(user)
    end

    describe "products" do
      before(:each) do
        user.cart = cart
        user.cart.add_product(product)
        visit admin_products_path
      end

      it "create" do
        click_link "New Product"

        fill_product_form

        expect {
         click_button "Create Product"
        }.to change{ Product.all.count }.by(1)
      end

      it "edit" do
        click_link "Edit"
        fill_in "product_title", :with => "Stuff"
        click_button "Update Product"
        find(".product_title").text.should == "Stuff"
      end

      it "view" do
        click_link "#{product.title}"
        page.should have_content "#{product.description}"
      end

      it "retire" do
        click_link "#{product.title}"
        click_link "Retire"
        find("#product_#{product.id}").should have_content("Retired")
      end
    end

    describe "category" do
      before(:each) do
        visit admin_categories_path
      end

      it "create" do
        click_link "New Category"
        fill_in "Name", :with => category.name
        click_button "Create Category"
        page.should have_content(category.name)
      end

      it "edit" do
        click_link "Edit"
        fill_in "Name", :with => "Darrell"
        click_button "Update Category"
        page.should have_content("Darrell")
      end

      it "view with associated products" do
        category.add_product(product)
        click_link "#{category.name}"
        page.should have_content("#{category.name}")
        page.should have_content("#{product.title}")
      end
    end

    context "orders" do
      it "views" do
        order.add_product(product)
        visit admin_orders_path
        click_link "#{order.id}"
        page.should have_content("#{order.items.first.title}")
      end

      context "edit and" do
        it "change the status" do
          visit admin_orders_path
          click_link "Edit"
          fill_in "Status", :with => "shipped"
          click_button "Update Order"
          visit admin_orders_path
          page.should have_content("shipped")
        end

        it "can't change quantity of products on non-pending orders" do
          order.status = "shipped"
          order.save
          order.add_product(product)
          visit admin_orders_path
          click_link "#{order.id}"
          page.should_not have_content("Edit")
        end

        it "remove products" do
          order.add_product(product)
          visit admin_order_path(order)
          click_link "Remove"
          page.should have_content("Item deleted.")
          page.should_not have_content(product.title)
        end

        it "change quantity of products on pending orders" do
          order.add_product(product)
          visit admin_orders_path
          find("#order_#{order.id}").click_link "Edit"
          fill_in "order_order_items_attributes_0_quantity", :with => "2"
          click_button "Update Order"
          visit admin_order_path(order)
          find(".quantity").text.should == "2"
        end
      end
    end
  end
end
