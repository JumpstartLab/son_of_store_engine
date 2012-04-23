require "spec_helper"

describe "Logging in/out and creating/destroying sessions" do
  let!(:user) { Fabricate(:auth_user) }
  let(:category) { Fabricate(:category) }
  before(:each) do
    login_user_post("whatever@whatever.com", "admin")
  end

  context "logging a user in" do 
    it "accepts a correct username and password" do
      visit user_path(user)
      page.should have_content("#{user.email}")
    end

    it "should allow admin to see dashboard" do
      visit category_path(category)
      within("ul.pull-right") do
        within "ul.dropdown-menu" do 
          page.should have_content("Dashboard")
        end
      end
    end
  end
  context "log a user out" do
    it "no longer links to their account" do
      visit logout_path
      page.should_not have_content("#{user.email}")
    end
  end
end