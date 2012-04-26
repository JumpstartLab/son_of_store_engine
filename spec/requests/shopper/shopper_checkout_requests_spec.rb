require 'spec_helper'

describe "shopper checkout", :shopper => true do
  let!(:store) { Fabricate(:store) }
  let!(:product) { Fabricate(:product, store_id: store.id) }

  before(:each) do
    visit "/#{store.to_param}"
  end

  context "checking out" do
    before(:each) { click_link_or_button "Add to Cart" }

    it "can add an item to the cart" do
      within "#cart-aside" do
        page.should have_content product.title
      end
    end

    it "does not overwrite cart items" do
      other_product = Fabricate(:product, store_id: store.id)
      visit "/#{store.to_param}"
      within "##{dom_id(other_product)}" do
        click_link_or_button "Add to Cart"
      end
      within "#cart-aside" do
        page.should have_content product.title
      end
    end

    it "increments products" do
      click_link_or_button "Add to Cart"
      within "#cart_item_title" do
        page.should have_content "2"
      end
    end

    it "removes a product by changing the quantity to 0" do
      within "#cart-aside" do
        page.should have_content "Update"
        click_link_or_button "Update"
      end
      fill_in :quantity, with: "0"
      click_link_or_button "Update Quantity"
      within "#cart-aside" do
        page.should_not have_content product.title
      end
    end

    it "views the cart" do
      within "#cart-aside" do
        page.should have_content "View Cart"
        click_link_or_button "View Cart"
      end
      current_path.should have_content "orders"
    end

    context "two-click checkout" do
      context "if the order has no billing or shipping info" do
        it "directs the user to input that information" do
          within "#cart-aside" do
            page.should have_content "Two-Click Check Out"
            click_link_or_button "Two-Click Check Out"
          end
          current_path.should have_content "orders"
          page.should have_content "valid billing and shipping"
          page.should have_content "Add a Billing Method"
          page.should have_content "Add a Shipping Address"
        end
      end

      context "if the order has billing and shipping information" do
        it "can do two-click checkout" do
          billing = Fabricate(:billing_method)
          shipping = Fabricate(:shipping_address)
          Order.last.update_attributes(billing_method_id: billing.id, shipping_address_id: shipping.id)
          within "#cart-aside" do
            page.should have_content "Two-Click Check Out"
            click_link_or_button "Two-Click Check Out"
          end
          current_path.should == "/#{store.to_param}/orders/lookup"
          page.should have_content Order.last.amount
          page.should have_content "Thank you"
        end
      end
    end

    context "regular checkout" do
      before(:each) do
        click_link_or_button "View Cart"
      end

      it "can add billing info" do
        click_link_or_button "Add a Billing Method"
        current_path.should == new_billing_method_path
        billing = {
          credit_card_number: "5555555555555555",
          month: "4",
          year: "2012",
          street: "One Mockingbird Lane",
          city: "Anytown",
          state: "Virginia",
          zipcode: "22209",
          card_type: 'Visa'
        }
        add_non_user_billing(billing)
      end

      it "can add shipping info" do
        click_link_or_button "Add a Shipping Address"
        current_path.should == new_shipping_address_path
        shipping = {street: "One Mockingbird Lane", city: "Anytown",
          state: "Virginia", zipcode: "22209",
          email_address: "test@test.com"}
          add_non_user_shipping(shipping)
        end

        it "can check out" do
          billing = Fabricate(:billing_method)
          shipping = Fabricate(:shipping_address)
          Order.last.update_attributes(billing_method_id: billing.id, shipping_address_id: shipping.id)
          within "#main-content" do
            page.should have_content "Check Out"
            click_link_or_button "Check Out"
          end
          current_path.should == "/#{store.to_param}/orders/lookup"
          page.should have_content Order.last.amount
          page.should have_content "Thank you"
        end

        it "does not checkout without valid billing" do
          shipping = Fabricate(:shipping_address)
          Order.last.update_attribute(:shipping_address_id, shipping.id)
          within "#main-content" do
            page.should have_content "Check Out"
            click_link_or_button "Check Out"
          end
          current_path.should have_content "orders"
          page.should have_content "Please input valid billing and shipping"
        end

        it "does not checkout without valid shipping" do
          billing = Fabricate(:billing_method)
          Order.last.update_attribute(:billing_method_id, billing.id)
          within "#main-content" do
            page.should have_content "Check Out"
            click_link_or_button "Check Out"
          end
          current_path.should have_content "orders"
          page.should have_content "Please input valid billing and shipping"
        end
      end
    end

    context "signing up" do
      it "can sign up" do
        click_link_or_button "Sign-Up"
        page.should have_selector ".new_user"
        sign_up({full_name: "Test User", email: "test@test.com",
         password: "test", display_name: "Test"})
        current_path.should == "/#{store.to_param}"
        page.should have_content "Welcome"
        page.should have_content "My Account"
      end

      it "can sign up and maintain its cart" do
        click_link_or_button "Add to Cart"
        click_link_or_button "Sign-Up"
        sign_up({full_name: "Test User", email: "test@test.com",
         password: "test", display_name: "Test"})
        visit "/#{store.to_param}/products"
        within "#cart-aside" do
          page.should have_content product.title
        end
      end
    end

    context "signing in" do
      let(:user) { Fabricate(:user) }

      it "creates a new session with this user" do
        click_link_or_button "Sign-In"
        login({email: user.email_address, password: user.password})
        current_path.should == "/#{store.to_param}"
        page.should have_content "Welcome"
        page.should have_content "My Account"
      end

      it "can sign in and maintain its cart" do
        click_link_or_button "Add to Cart"
        click_link_or_button "Sign-In"
        login({email: user.email_address, password: user.password})
        within "#cart-aside" do
          page.should have_content product.title
        end
      end
    end
end
