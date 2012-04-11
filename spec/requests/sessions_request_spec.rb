require "spec_helper"

describe "Logging in/out and creating/destroying sessions" do
  let!(:user){Fabricate(:auth_user)}
  before(:each) do
    login_user_post("whatever@whatever.com", "admin")
  end

  context "logging a user in" do 
    it "accepts a correct username and password" do
      visit user_path(user)
      page.should have_content("#{user.email}")
    end
  end
end