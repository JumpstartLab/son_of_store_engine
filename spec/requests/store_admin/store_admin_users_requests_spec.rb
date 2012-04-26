require 'spec_helper'

describe "store admin for users", store_admin: true do
  let!(:user) { Fabricate(:user) }
  let!(:store) { Fabricate(:store) }
  let!(:product) { Fabricate(:product, store_id: store) }
  
  before(:each) do
    user.update_attribute(:admin, true)
    user.update_attribute(:admin_view, true)
    visit "/#{store.to_param}/products"
    click_link_or_button "Sign-In"
    login({email: user.email_address, password: user.password})
  end

  context "user" do
    let!(:other_user) { Fabricate(:user) }

    it "cannot edit another user's information" do
      visit "/#{store.to_param}/admin/users/#{other_user.to_param}"
      click_link_or_button "Change Profile"
      current_path.should == "/"
      page.should have_content "not allowed"
    end
    
    it "can view a list of users" do
      visit "/#{store.to_param}/admin/users"
      page.should have_content other_user.full_name
    end
  end
end