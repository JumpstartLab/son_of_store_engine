require 'spec_helper'

describe User do
  let! (:user) { Fabricate(:user) }
  let! (:second_user) { Fabricate(:user) }
  let! (:store) { Fabricate(:store, :users => [user]) }
  let! (:product) { Fabricate(:product, :store => store) }
  let! (:cart) { Fabricate(:cart, :store => store) }

  after(:all) do
    User.destroy_all
  end

  context "with role admin can" do
    let(:address) { Fabricate(:address) }
    let!(:category) { Fabricate(:category, :store => store) }
    let!(:product) { Fabricate(:product, :store => store) }
    let!(:order) {
      Fabricate(
        :order,
        :user_id => user.id,
        :address_id => address.id
      )
    }

    before(:each) do
      user.set_role('admin')
      second_user.set_role('admin')
      visit products_path(store)
      login_as(user)
    end

    describe "the admin dashboard" do
      it "provides a button to add a new admin user" do
        visit admin_dashboard_path(store)
        page.should have_link "Manage Users"
      end

      context "the manage users page" do
        let!(:new_admin) { Fabricate(:user) }

        before(:each) do
          click_link "Admin"
          click_link "Manage Users"
        end

        it "allows an admin to make a new admin via a user's email address" do
          page.should have_content("Add New Administrator")
        end

        context "when an admin who is not a valid sonofstoreengine user is added" do
          before(:each) do
            fill_in "Email", :with => "bogusemailaddress@email123.com"
          end

          it "validates the new admin's e-mail address as a valid sonofstoreengine user" do
            click_button "Add Admin"
            page.should have_content "User with email 'bogusemailaddress@email123.com' does not exist."
          end

          it "emails the invalid admin asking them to join sonofstoreengine" do
            expect { click_button "Add Admin" }.to change(ActionMailer::Base.deliveries, :size).by(1)
          end
        end

        it "allows an admin to set another user as an admin for the store" do
          fill_in "Email", :with => new_admin.email
          expect { click_button "Add Admin" }.to 
                  change{ store.users.count }.by(1)
        end

        context "when a new store admin has been successfully added" do
          it "emails the new store administrator" do
            fill_in "Email", :with => new_admin.email
            expect { click_button "Add Admin" }.to change(ActionMailer::Base.deliveries, :size).by(1)
          end
        end

        it "displays an 'new admin successfully added' message when an admin has been added" do
          fill_in "Email", :with => new_admin.email
          click_button "Add Admin"
          page.should have_content "New admin successfully added."
        end

        it "allows an admin to delete another admin" do
          page.should have_content("Remove Admin")
        end

        it "allows an admin to delete any current store admin" do
          expect { click_button "Delete Admin" }.to 
                  change{ store.users.count }.by(1)
        end

        it "displays an 'admin deleted' message when an admin has been removed" do
          click_button "Delete Admin"
          page.should have_content("Admin deleted")
        end

        context "when a store admin has been deleted" do
          it "notifies the deleted admin that they have been removed via email" do
            expect {click_button "Delete Admin" }.to change(ActionMailer::Base.deliveries, :size).by(1)
          end
        end
      end
    end

    describe "products" do
      before(:each) do
        user.cart = cart
        user.cart.add_product(product)
        visit admin_products_path(store)
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

      it "modify a product with a blank photo, displaying default image" do
        click_link "Edit"
        fill_in "Photo", :with => ''
        click_button "Update Product"
        click_link "#{product.title}"
        page.should have_xpath("//img[@src=\"#{DEFAULT_PHOTO}\"]")
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
        visit admin_categories_path(store)
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
        visit admin_orders_path(store)
        click_link "#{order.id}"
        page.should have_content("#{order.items.first.title}")
      end

      context "edit and" do
        it "change the status" do
          visit admin_orders_path(store)
          click_link "Edit"
          fill_in "Status", :with => "shipped"
          click_button "Update Order"
          visit admin_orders_path(store)
          page.should have_content("shipped")
        end

        it "can't change quantity of products on non-pending orders" do
          order.status = "shipped"
          order.save
          order.add_product(product)
          visit admin_orders_path(store)
          click_link "#{order.id}"
          page.should_not have_content("Edit")
        end

        it "remove products" do
          order.add_product(product)
          visit admin_order_path(store, order)
          click_link "Remove"
          page.should have_content("Item deleted.")
          page.should_not have_content(product.title)
        end

        it "change quantity of products on pending orders" do
          order.add_product(product)
          visit admin_orders_path(store)
          find("#order_#{order.id}").click_link "Edit"
          fill_in "order_order_items_attributes_0_quantity", :with => "2"
          click_button "Update Order"
          visit admin_order_path(store, order)
          find(".quantity").text.should == "2"
        end
      end
    end
  end
end
