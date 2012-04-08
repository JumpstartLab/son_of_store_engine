require 'spec_helper'

describe "Application Requests" do
  context "homepage" do
    before(:each) do
      visit "/"
    end
    if current_user.is_admin
      context "layout" do
        context "user is admin" do
          it "should have a link to the order dashboard" do
            visit "/"
            page.should have_link("Dashboard", :href => orders_path)
          end
        end
      end
    end
    it "shows the cart in the nav bar" do
      page.should have_content("Cart")
    end

    it "shows cart as empty" do
      page.should have_content("Nothing in your cart!")
    end

    it "has a link to sign-up" do
      page.should have_link("Sign up", :href => "/signup")
    end

    it "has a link to login (no one should be logged in)" do
      page.should have_link("Login", :href => "/login")
    end

  end
end
