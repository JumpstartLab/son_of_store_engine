require 'spec_helper'

describe User, :user_request => :user do
  let (:user) { Fabricate(:user) }
  let (:product) { Fabricate(:product) }
  let (:cart) { Fabricate(:cart) }

  after(:all) do
    User.destroy_all
  end

  it "can signup a unique user" do
    user.email = user.email + 'unique'
    create_user(user)
    page.should have_content("Welcome! You have signed up successfully.")
  end

  it "can't signup with a duplicate email" do
    create_user(user)
    page.should have_content("Email has already been taken")
  end

  it "can't login with an invalid email" do
    user.email = 'invalid@1337807.com'
    login_as(user)
    page.should have_content("Invalid email or password.")
  end

  it "can logout" do
    login_as(user)

    click_link("Log out")
    page.should have_content("Signed out successfully.")
  end

  context "after signing up" do
    it "user receives confirmation email" do
      expect { create_user(user) }.to change(ActionMailer::Base.deliveries,:size).by(1)
    end
  end

  context "after logging in" do
    before(:each) do
      visit product_path(product)
      click_link "Add to Cart"
      login_as(user)
    end

    it "preserves the contents of my cart" do
      visit cart_path
      page.should have_content(product.title)
    end

    it "can view their orders" do
      visit cart_path
      click_link "Checkout"
      fill_billing_form
      click_button "Submit"
      visit orders_path
      page.should have_link("#{product.price}")
    end
  end

  context "an unauthenticated user" do
    it "can't create new products" do
      visit new_admin_product_path
      page.should have_content("Sign in")
      page.should have_content("You need to sign in or sign up")
    end
  end

  describe "with role" do
    context "nil" do
      it "cannot visit the new product page" do
        login_as(user.set_role(nil))
        visit new_admin_product_path
        error = "Access denied. This page is for administrators only."
        page.should have_content(error)
        page.should have_content("Products")
      end
    end

    context "'blank'" do
      it "cannot visit the new product page" do
        login_as(user.set_role(''))
        visit new_admin_product_path

        error = "Access denied. This page is for administrators only."
        page.should have_content(error)
        page.should have_content("Products")
      end
    end

    context "puppy" do
      before(:all) do
        user.role = nil
      end

      it "cannot visit the new product page" do
        login_as(user)
        visit new_admin_product_path

        error = "Access denied. This page is for administrators only."
        page.should have_content(error)
        page.should have_content("Products")
      end
    end
  end
end
