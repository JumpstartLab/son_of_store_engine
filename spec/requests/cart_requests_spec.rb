require 'spec_helper'

describe Cart do
  let(:user) { Fabricate(:user) }
  let!(:store) { Fabricate(:store, :users => [user]) }
  let!(:product) { Fabricate(:product, :store => store) }
  let!(:second_product) { Fabricate(:product, :store => store) }
  let!(:cart) { Fabricate(:cart, :store => store) }
  let!(:category) { Fabricate(:category, :store => store) }
  let!(:unsaved_user) { Fabricate.build(:user) }

  context "as an unauthenticated user" do
    context "when I click checkout with a product in my cart" do
      before(:each) do
        visit product_path(store, product)
        click_link 'Add to Cart'
        click_link "Checkout"
      end

      it "I can sign up for an account" do
        page.should have_link("Sign up")
      end

      it "I can Log In to my existing account" do
        page.should have_link("Log In")
      end

      it "I can checkout as a guest" do
        page.should have_link("Checkout as guest")
      end

      context "when I click 'Sign up'" do
        before(:each) do
          click_link "Sign up"
        end

        it "prompts me to create an account" do
          find('h2').should have_content("Sign up")
        end

        describe "when I create my account" do
          before(:each) do
            complete_user_form(unsaved_user)
            click_button "Sign up"
          end

          it "I am prompted for my billing information" do
            page.should have_content("Billing Information")
          end

          it "after entering billing information I see my order confirmation" do
            fill_billing_form
            click_button "Submit"
            page.should have_selector("#order_number")
            page.should have_content("Order placed. Thank you!")
          end
        end
      end

      context "when I click 'Log In'" do
        before(:each) do
          click_link "Log In"
        end

        it "prompts me to Log In" do
          find('h2').should have_content("Log In")
        end

        describe "when I sign in to my account" do
          before(:each) do
            login_as(user)
          end

          it "I am prompted for my billing information" do
            page.should have_content("Billing Information")
          end

          it "after entering billing information I see my order confirmation" do
            fill_billing_form
            click_button "Submit"
            page.should have_selector("#order_number")
            page.should have_content("Order placed. Thank you!")
          end
        end
      end

      context "when I click checkout as guest" do
        before(:each) do
          click_link "Checkout as guest"
        end

        describe "I'm prompted for my billing information" do
          it "including my email address" do
            page.should have_field(:email)
          end

          it "including my billing address" do
            page.should have_field(:billing_address)
          end

          it "including my shipping address" do
            page.should have_field(:shipping_address)
          end

          it "including my credit card" do
            page.should have_field(:credit_card)
          end
        end

        describe "when I submit my order" do
          before(:each) do
            click_button "Submit"
          end

          it "I see a thank you message" do
            page.should have_content("Order placed. Thank you!")
          end

          it "I see a link to a unique hashed url" do
            page.should have_link("unique_url")
          end

          describe "when I click unique hashed url link" do
            before(:each) do
              click_link "unique_url"
            end

            it "I see my order details" do
              page.should have_selector("#order_number")
            end

            it "I don't see a flash message thanking me for my order" do
              page.should_not have_content("Order placed. Thank you!")
            end
          end
        end


        it "when I submit my order I receive a confirmation email" do
          expect { click_button "Submit" }.to change(ActionMailer::Base.deliveries, :size).by(1)
        end
      end
    end
  end

  context "as an authenticated user" do
    context "when I click checkout with a product in my cart" do
      before(:each) do
        visit products_path(store)
        cart.add_product(product)
        login_as(user)
        visit cart_path(store)
      end

      it "takes me to a billing page" do
        click_link "Checkout"
        page.should have_content("Billing Information")
      end

      it "creates a pending order" do
        count = Order.find_all_by_status("pending").count
        expect {
          click_link "Checkout"
        }.to change{ Order.find_all_by_status("pending").count }.by(1)
      end

      context "and I submit new billing information" do
        before(:each) do
          click_link "Checkout"
        end

        it "creates a credit card" do
          fill_billing_form
          expect {
            click_button "Submit"
          }.to change{ CreditCard.count }.by(1)
        end

        it "creates an address" do
          fill_billing_form
          expect {
            click_button "Submit"
          }.to change{ Address.count }.by(1)
        end

        it "creates a paid order" do
          fill_billing_form
          expect {
            click_button "Submit"
          }.to change{ Order.find_all_by_status("paid").count }.by(1)
        end

        it "redirects me to see my order" do
          fill_billing_form
          click_button "Submit"
          page.should have_content("Thank you!")
          find('h2').should have_content("Order")
        end

        it "clears my cart" do
          fill_billing_form
          click_button "Submit"
          visit cart_path(store)
          page.should have_content("Your Cart is Empty.")
        end

        context "paid order" do
          before(:each) do
            fill_billing_form
            click_button "Submit"
          end

          it "shows the status as paid" do
            page.should have_content("paid")
          end

          it "shows me the order total" do
            page.should have_content(user.orders.last.total)
          end
        end
      end
    end
  end

  context "when a user clicks on 'add to cart'" do
    before(:each) do
      visit product_path(store, product)
      click_link "Add to Cart"
    end

    it "adds the product to the cart" do
      visit cart_path(store)
      within ("#cart") do
        page.should have_content(product.title)
      end
    end

    it "shows the correct total in the cart" do
      find('#total').should have_content(product.price)
    end
  end

  context "when an authenticated user clicks on 'add to cart'" do
    before(:each) do
      login_as(user)
      visit product_path(store, product)
      click_link "Add to Cart"
    end

    it "adds the product to the cart" do
      visit cart_path(store)
      within ("#cart") do
        page.should have_content(product.title)
      end
    end

    it "shows the correct total in the cart" do
      find('#total').should have_content(product.price)
    end
  end

  context "is linked from" do
    it "the products page" do
      visit products_path(store)
      page.should have_content("View Cart")
    end

    it "a product page" do
      visit product_path(store, product)
      page.should have_content("View Cart")
    end

    it "a category page" do
      visit category_path(store, category)
      page.should have_content("View Cart")
    end
  end

  context "can be visited by clicking 'View Cart' from" do
    it "the products page" do
      visit products_path(store)
      click_link "View Cart"
      page.should have_content("Your Cart")
    end

    it "a product page" do
      visit product_path(store, product)
      click_link "View Cart"
      page.should have_content("Your Cart")
    end

    it "a category page" do
      visit category_path(store, category)
      click_link "View Cart"
      page.should have_content("Your Cart")
    end

    context "clicking the 'Keep Shopping' link from the cart show page" do
      it "should redirect you back to the products page" do
        visit products_path(store)
        click_link "View Cart"
        click_on("Keep Shopping")
        current_path.should == products_path(store)
        page.should have_content(store.products.first.title)
      end
    end
  end

  context "when I click on remove" do
    before(:each) do
      visit product_path(store, product)
      click_link "Add to Cart"
      click_link "Remove Item"
    end

    it "removes the product from my cart" do
      page.should_not have_content(product.title)
    end
  end

  context "when I increase the quantity of a product and click update cart" do
    before(:each) do
      visit product_path(store, product)
      click_link "Add to Cart"
      fill_in "order_item_quantity", :with => "2"
      @previous_total = find("#total").text.to_f
      @previous_subtotal = find(".subtotal").text.to_f
      click_button "Change Quantity"
    end

    it "changes the quantity in the cart" do
      find("#order_item_quantity").value.should == "2"
    end

    it "increases the subtotal for that product" do
      find(".subtotal").text.to_f.should > @previous_subtotal
    end

    it "increases the total of the cart" do
      find("#total").text.to_f.should > @previous_total
    end
  end

  # context "when I increase the quantity of multiple products and click update cart" do
  #   before(:each) do
  #     visit product_path(store, product)
  #     click_link "Add to Cart"
  #     click_button("Keep Shopping")
  #     visit product_path(store, second_product)
  #     click_link "Add to Cart"
  #     fill_in "cart_order_item_quantity", :with => "2"

  #     page.should have_content("label[for$='category_name']")
  #           page.should have_selector("input[id$='category_name']")


  #     @previous_subtotal_1 = find(".subtotal").text.to_f
  #     fill_in "cart_order_item_quantity", :with => "3"
  #     @previous_subtotal = find(".subtotal").text.to_f
  #     click_button "Update Cart"
  #   end

  #   it "changes the quantity in the cart" do
  #     find("#cart_order_item_quantity").value.should == "2"
  #   end

  #   it "increases the subtotal for that product" do
  #     find(".subtotal").text.to_f.should > @previous_subtotal
  #   end

  #   it "increases the total of the cart" do
  #     find("#total").text.to_f.should > @previous_total
  #   end
  # end
end
