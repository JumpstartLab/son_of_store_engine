require 'spec_helper'

describe "Creating stores" do
  let!(:user) { FactoryGirl.create(:user, :admin => true) }

  context "and I'm logged in" do
    before(:each) do
      #set_host("woraces-workshop")
      visit "/sessions/new"
      fill_in "email", with: user.email
      fill_in "password", with: "foobar"
      click_link_or_button('Log in')
      visit user_path(user)
    end

    it "lets me create a store from my profile page" do
      page.should have_content('Create a store')
    end

    context "and I click 'Create a store'" do
      before(:each) { click_link_or_button('Create a store') }

      it "takes me to the new store creation page" do
        page.should have_content('New store')
      end
    end
  end
end