require 'spec_helper'

describe "shopper account information requests" do
  let!(:user)   { Fabricate(:user) }
  
  before(:each) do
    visit "/"
    click_link_or_button "Sign-In"
    login({email: user.email_address, password: user.password})
  end
  
  context "billing method information" do
    context "updating an existing billing method" do
      let!(:billing_method)   { Fabricate(:billing_method, user_id: user.id) }
      
      before(:each) do
        visit "/profile"
        click_link_or_button "Change Billing Method"
      end
      
      context "using invalid data" do
        before(:each) do
          fill_in "Street", with: " "
          click_link_or_button "Update Billing method"
        end
        
        it "returns an error" do
          page.should have_content "Street can't be blank"
        end
      end
    end
  end
  
  context "shipping method information" do
    context "updating an existing shipping method" do
      let!(:shipping_address)   { Fabricate(:shipping_address, user_id: user.id) }
      
      before(:each) do
        visit "/profile"
        click_link_or_button "Change Shipping Address"
      end
      
      context "using invalid data" do
        before(:each) do
          fill_in "Street", with: " "
          click_link_or_button "Update Shipping address"
        end
        
        it "returns an error" do
          page.should have_content "Street can't be blank"
        end
      end
    end
  end
end