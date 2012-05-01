require 'spec_helper'

describe "User" do
  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user, :email => "test@test.com") }
  let!(:address) { FactoryGirl.create(:address, :user => user) }

  context "fails login" do
    it "fails login" do
      visit '/login'
      fill_in 'account_name', with: user.email
      click_button("Log In")
      page.should have_content("Email or password is invalid.")
    end
  end

  context "when logged in" do
    before(:each) { login(user) }
    it "logs me out" do
      visit '/'
      click_on "Log Out"
      page.should have_content "Logged out"
    end
  end

  context "view a user" do
    it "requires login" do
      visit user_path(user)
      page.should have_content "You need to log in first"
    end

    context "while logged in" do
      it "shows the user page" do
        login(user)
        visit user_path(user)
        page.should have_content user.full_name
      end

      it "shows addresses associated with this user" do
        login(user)
        visit user_path(user)
        page.should have_content(address.city)
      end
    end
  end

  context "edit user" do
    it "requires login" do
      visit edit_user_path(user)
      page.should have_content "You need to log in first."
    end

    context "while logged in" do
      before(:each) { login(user) }
      it "displays the edit user page" do
        visit edit_user_path(user)
        page.should have_content(user.full_name)
        page.should have_content("Account Settings")
      end

      it "only for the current user" do
        visit edit_user_path(user2)
        page.should have_content "You can only edit yourself."
      end
    end
  end

  context "creating new users" do
    before(:each) do
      visit root_path
      visit new_user_path 
    end

    it "does not requires login" do
      page.should have_css('h1', :text => 'Sign Up')
    end

    it "creates a user given valid attributes" do
      fill_in "user[full_name]", :with => "Luke Skysauce"
      fill_in "user[email]", :with => "sky@walker.com"
      fill_in "user[password]", :with => "foobar"
      fill_in "user[password_confirmation]", :with => "foobar"
      click_on "Create User"
      page.current_path.should == root_path
    end

    it "fails to create a user given invalid attributes" do
      fill_in "user[full_name]", :with => "Luke Skysauce"
      fill_in "user[password]", :with => "foobar"
      fill_in "user[password_confirmation]", :with => "foobar"
      click_on "Create User"
      page.should have_content "can't be blank"
    end
  end

  context "editing users" do
    it "users can't edit other users" do
      login(user2)
      visit edit_user_path(user)
      page.should have_content "You can only edit yourself"
    end

    it "users can edit themselves" do
      login(user)
      visit edit_user_path(user)
      page.should have_content "Account Settings for #{user.full_name}"
    end

    it "successfuly allows users to edit themselves" do
      login(user)
      visit edit_user_path(user)
      fill_in "user[full_name]", :with => "Joss Whedon"
      fill_in "user[password]", :with => "foobar"
      fill_in "user[password_confirmation]", :with => "foobar"
      click_on "Update User"
      page.should have_content "Joss Whedon"
    end

    it "rejects invalid edits" do
      login(user)
      visit edit_user_path(user)
      fill_in "user[full_name]", :with => ""
      fill_in "user[password]", :with => "foobar"
      fill_in "user[password_confirmation]", :with => "foobar"
      click_on "Update User"
      page.should have_content "can't be blank"
    end
  end

  context "when signing up" do
    let (:product) { FactoryGirl.create(:product) }

    it "returns user to previous page" do
      visit store_product_path(product.store, product)
      click_link "Sign Up"
      fill_in "user[full_name]", :with => "Luke Skysauce"
      fill_in "user[email]", :with => "sky@walker.com"
      fill_in "user[password]", :with => "foobar"
      fill_in "user[password_confirmation]", :with => "foobar"
      click_on "Create User"
      page.current_path.should == store_product_path(product.store, product)
    end

    it "shows flash with link to edit settings" do
      visit root_path
      click_link "Sign Up"
      fill_in "user[full_name]", :with => "Luke Skysauce"
      fill_in "user[email]", :with => "sky@walker.com"
      fill_in "user[password]", :with => "foobar"
      fill_in "user[password_confirmation]", :with => "foobar"
      click_on "Create User"
      find_link("Edit User Settings").visible?.should == true
    end

    it "redirects to root if previous page was signup" , :requests => :signup do
      visit new_user_path
      click_link "Sign Up"
      fill_in "user[full_name]", :with => "Luke Skysauce"
      fill_in "user[email]", :with => "sky@walker.com"
      fill_in "user[password]", :with => "foobar"
      fill_in "user[password_confirmation]", :with => "foobar"
      click_on "Create User"
      page.current_path.should == root_path
    end
  end
end
