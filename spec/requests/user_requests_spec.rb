require 'spec_helper'

describe User, :user_request => :user do
  let(:store) { Fabricate(:store) }
  let (:user) { Fabricate(:user) }
  let (:product) { Fabricate(:product, :store => store) }
  let (:cart) { Fabricate(:cart, :store => store) }

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

  context "when a new user visits the sign up link" do
    it "should be directed to the top-level url http://sonofstoreengine.com/users/new" do
      visit 'root'
      click_link 'Sign up'
      uri = URI.parse(current_url)
      uri.path.should == "/users/new"
    end
  end

  context "after signing up" do
    let(:user) { Fabricate.build(:user) }
    it "user sees a confirmation flash message with a link to change their account" do
      visit new_user_path
      complete_user_form(user)
      click_button "Sign up"
      page.should have_content("Change your account")
    end

    it "user receives confirmation email" do
      expect { create_user(user) }.to change(ActionMailer::Base.deliveries,:size).by(1)
    end
  end

  context "after logging in" do
    before(:each) do
      visit product_path(store, product)
      click_link "Add to Cart"
      login_as(user)
    end

    it "preserves the contents of my cart" do
      visit cart_path(store)
      page.should have_content(product.title)
    end

    it "can view their orders" do
      visit cart_path(store)
      click_link "Checkout"
      fill_billing_form
      click_button "Submit"
      visit orders_path(store)
      page.should have_link("#{product.price}")
    end
  end

  context "an unauthenticated user" do
    it "can't create new products" do
      visit new_admin_product_path(store)
      page.should have_content("Log In")
      page.should have_content("You are not authorized to access this page.")
    end
  end

  it "with role 'puppy' cannot visit the new product page" do
    user.add_role(Role.create(:name => 'puppy'))
    login_as(user)
    visit new_admin_product_path(store)

    error = "You are not authorized to access this page."
    page.should have_content(error)
  end

  describe "superadmins" do
    it "can edit users" do
      login_as_superadmin(user)
      visit edit_user_registration_path(user)
      page.should_not have_content "You are not authorized to access this page."
      page.should have_button "Update My Account"
    end
  end

  describe "admins" do
    it "can't edit users" do
      login_as_admin(user)
      visit edit_user_path(user)
      page.should have_content "You are not authorized to access this page."
    end
  end

  describe "unauthenticated users" do
    it "can't edit users" do
      login_as(user)
      visit edit_user_path(user)
      page.should have_content "You are not authorized to access this page."
    end
  end
end
