require 'spec_helper'

describe Store do
  context "when the user is authenticated" do
    let!(:user)   { Fabricate(:user) }
    before(:each) do
      visit "/"
      click_link_or_button "Sign-In"
      login({email: user.email_address, password: user.password})
    end

    context "from the user's profile page" do
      before(:each) do
        visit "/profile"
        find("#create_new_store").click
      end

      context "using valid information" do
        before(:each) do
          fill_in "Name", :with => "Test Store"
          fill_in "Domain", :with => "test-store"
          click_button "Create Store"
          @store = Store.last
        end

        it "display the store show page for the new store" do
          current_path.should == admin_store_path(@store)
          find("#store_name").text.should have_content @store.name
          find("#store_domain").text.should have_content @store.domain
          find("#store_approval_status").text.should have_content "pending"
          find("#store_active_status").text.should have_content "Disabled"
        end

        it "returns a not found error when visit the store show page" do
          visit "/#{@store.to_param}"
          page.should have_content "page cannot be found"
        end
      end

      context "using an existing store name" do
        let!(:existing_store)  { Fabricate(:store) }

        before(:each) do
          fill_in "Name", :with => existing_store.name
          fill_in "Domain", :with => "not-latin"
        end

        it "return an error stating that the name has been taken" do
          expect { click_button "Create Store" }.to_not change{ Store.count }.by(1)
          current_path.should == stores_path
          page.should have_content "Name has already been taken"
        end
      end

      context "using an existing domain name" do
        let!(:existing_store)  { Fabricate(:store) }

        before(:each) do
          fill_in "Name", :with => "not-latin"
          fill_in "Domain", :with => existing_store.domain
        end
        it "return an error stating that the domain has been taken" do
          expect { click_button "Create Store" }.to_not change{ Store.count }.by(1)
          current_path.should == stores_path
          page.should have_content "Domain has already been taken"
        end
      end
    end
  end
end
