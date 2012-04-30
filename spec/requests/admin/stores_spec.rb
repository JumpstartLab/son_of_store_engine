require 'spec_helper'


describe "Administrator store pages" do
  let!(:admin_user) { FactoryGirl.create(:user, :admin => true) }
  let!(:test_two_store) { FactoryGirl.create(:store, :owner_id => admin_user.id) }

  before(:each) do
    test_two_store.add_admin(admin_user)
    visit "/sessions/new"
    fill_in "email", with: admin_user.email
    fill_in "password", with: "foobar"
    click_link_or_button("Log in")
  end

  context "admin visits admin page page for store" do
    before (:each) do
      visit admin_store_url(:subdomain => test_two_store.url_name)
    end


    describe "allows admin to click a link to edit store details" do

      it "does something" do

      end

      it "has an edit link that takes you to the edit page" do
        pending
        page.should have_content('Edit Store')
        # click_link_or_button('Edit Store')
      end

      it "takes you to the edit page when you click the edit store link" do
        pending
        click_link_or_button('Edit Store')
        page.should have_selector('#edit')
      end

      # it "allows you to edit the name" do
      #   click_link_or_button('Edit Store')
      #   # visit edit_admin_store_path(@store_id)
      #   save_and_open_page
      # end

      it "gives a flash message when you edit the name" do
        pending
      end
    end
  end
end