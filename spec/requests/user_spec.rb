require 'spec_helper'

describe "User" do
  let!(:store) do
    FactoryGirl.create(:store)
  end
  before(:each) do
    Capybara.app_host = "http://#{store.url}.son.test"
  end  
  let!(:user) do 
    FactoryGirl.create(:admin, :password => "mike")
  end
  let!(:user2) do 
    FactoryGirl.create(:user)
  end
  context "Failed Login" do
    it "Fails Login" do
      visit '/login'
      fill_in 'user[email]', :with => user.email
      fill_in 'user[password]', :with => "jiberish"
      click_button("Sign In")
      page.should have_content("incorrect username or password")
    end
  end
  context "Edit User" do 
    it "needs to login before editing" do
      visit edit_user_path(user2)
      page.should have_content "You must login first"
    end
    context "After login" do
      before(:each) do
        login(user)
      end
      it "can't resign up" do
        visit new_user_path
        page.should have_content("Must not be logged in")
      end      
      it "can edit themselves" do
        visit edit_user_path(user)
        page.should have_content("Edit User")
        fill_in 'user[name]', :with => "rabble"
        click_on "Edit User"
        page.should have_content("Update successful")        
      end
      it "has validation on update" do 
        visit edit_user_path(user)
        fill_in 'user[name]', :with => ""
        click_on "Edit User"
        page.should have_content("Edit User")        
      end
    end
    it "User can signup" do
      visit new_user_path
      fill_in 'user[email]', :with =>  "Jiberish@yahoo.com"
      fill_in "user[password]", :with => "mike"
      fill_in "user[name]", :with => "mike"  
      click_on "Sign up"
      page.should have_content("Account successfully made!")
    end
    it "User verifies auth" do
      visit new_user_path
      fill_in 'user[email]', :with =>  ""
      fill_in "user[password]", :with => ""
      fill_in "user[name]", :with => ""
      click_on "Sign up"     
      page.should have_content("can't be blank") 
    end
  end
  context "Admin User Modifications" do
    before(:each) do
      login(user)
      visit admin_users_path
    end
    it "lists all the users" do
      page.should have_content user.name
    end
    it "removes user" do
      within("#user_#{user2.id}") do
        click_on "X"
      end
      page.should_not have_content(user2.email)
    end
  end
end