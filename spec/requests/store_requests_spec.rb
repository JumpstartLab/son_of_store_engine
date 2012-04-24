require 'spec_helper'

describe Store do
  context "creating a new store" do
    let!(:user)   { Fabricate(:user) }

    context "when the user is authenticated" do
      before(:each) do
        visit "/"
        click_link_or_button "Sign-In"
        login({email: user.email_address, password: user.password})
      end

      context "from the user's profile page" do
        before(:each) do
          visit "/profile"
          find("#create_new_store").click
          fill_in "Name", :with => "Test Store"
          fill_in "Domain", :with => "test-store"
          click_button "Create Store"
          @store = Store.last
        end

        it "display the store show page for the new store" do
          current_path.should == store_path(@store)
          find("#store_name").text.should have_content @store.name
          find("#store_domain").text.should have_content @store.domain
          find("#store_status").text.should have_content "pending"
        end
      end
    end
  end
end