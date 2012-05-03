require 'spec_helper'

describe "When I want to place an order" do
  let!(:store) { Store.find_by_url_name("best-sunglasses") }
  let!(:user) { FactoryGirl.create(:user) }
  let(:product) { FactoryGirl.create(:product, :store_id => store.id) }

  before(:each) do
    set_host("best-sunglasses")
  end

  context "as an unauthenticated user" do
    context "and I add an item to my cart" do
      before(:each) do
        visit product_path(product)
        click_link_or_button("Add to cart")
        visit cart_path
      end
      context "and I try to checkout" do
        before(:each) do
          click_link_or_button("Checkout")
        end

        it "takes me to the sign-in page" do
          current_path.should == signin_path
        end

        it "shows an option to register a new account" do
          within("#sign_up") do
            page.should have_content("Sign up!")
          end
        end

        context "and I register as a new user" do
          before(:each) do
            click_link_or_button("Sign up!")
          end
          it "takes me to the signup page" do
            current_path.should == signup_path
          end

          it "redirects me back to the checkout process after registering" do
            within("#new_user") do
              fill_in "email", with: 'test@test.com'
              fill_in "name", with: 'testuser'
              fill_in "display_name", with: 'bomb-diggity'
              fill_in "password", with: 'hungry'
              fill_in "password_confirmation", with: 'hungry'
              click_link_or_button('Create Account')
              current_path.should == new_credit_card_path
            end
          end
        end

        context "and I log in under an existing account" do
          context "and I have no previous billing info" do
            it "takes me back to the checkout process at the add credit_card stage" do
              fill_in "email", with: user.email
              fill_in "password", with: 'foobar'
              click_link_or_button('Log in')
              current_path.should == new_credit_card_path
            end
          end
        end
      end
    end
  end

  context "as a logged-in user" do
    before(:each) do
      visit "/sessions/new"
      fill_in "email", with: user.email
      fill_in "password", with: "foobar"
      click_link_or_button('Log in')
    end

    context "and I visit a product's page" do
      before(:each) { visit product_path(product) }

      context "and I add the product to my cart" do
        before(:each) { click_link_or_button('Add to cart') }
        it "should update my cart count" do
          page.should have_content("Cart (1)")
        end

        context "and I want to place an order" do
          before(:each) { visit new_order_path }

          it "prompts me to add a credit card" do
            page.should have_content('Add a Credit Card')
          end

          context "and I submit valid information" do
            let(:stripe_card_token) { "tok_KM1feeMHDhSgiq" }
            let(:json) { JSON.parse(IO.read('spec/fixtures/stripe_new_customer_success.json')) }
            before(:each) do
              CreditCard.any_instance.stub(:add_details_from_stripe_card_token).and_return(true)
              fill_in "Credit Card Number", with: 4242424242424242
              fill_in "Security Code on Card (CVV)", with: 234
              select("2 - February", from: :card_month)
              select("2014", from: "card_year")
              click_link_or_button('Create Credit card')
            end
          end

        end
      end
    end

    context "and I submit enter valid information" do
      before(:each) do
        fill_in "Credit Card Number", with: 123
        click_link_or_button('Create Credit card')
      end

      # it "should stay on the current page" do
      #   page.should have_content("New Order")
      # end
    end


    context "and I enter valid information" do
      before do
        fill_in "Credit Card Number", with: 4242424242424242
        fill_in "Security Code on Card (CVV)", with: 234
        select("1 - January", from: :card_month)
        select("2013", from: "card_year")
      end

      #it "takes me to the order confirmation page"
      # need to figure out some way to test without making an inline API call
    end

    context "user already has shipping and credit information loaded" do

      describe "user checks out a cart with content" do
        # let!(:shipping_detail) { FactoryGirl.create(:shipping_detail, user_id: user.id) }
        # let!(:credit_card) { FactoryGirl.create(:credit_card, user_id: user.id) }

        # before(:each) do
        #   visit product_path(product)
        #   click_link_or_button('Add to cart')
        #   click_link_or_button('Checkout')
        #   click_link_or_button('Create Order')
        # end

      end

    end
  end
end
