require 'spec_helper'


describe "Given user is a store administrator" do
  let!(:admin_user) { FactoryGirl.create(:user, :admin => true) }

  context "admin visits admin page page for store" do
    before (:each) do
      visit "/sessions/new"
      fill_in "email", with: admin_user.email
      fill_in "password", with: "foobar"
      click_link_or_button("Log in")
      visit user_path(admin_user)
      click_link_or_button('Create a store')
      name = Faker::Lorem.words(1)
      url_name = name
      store_description = Faker::Lorem.paragraph(1)
      fill_in "store_name", with: name
      fill_in "store_url_name", with: url_name
      fill_in "store_description", with: store_description
      click_link_or_button('Create Store')
      @test_store = Store.all.last
    end


    describe "allows admin to click a link to edit store details" do

      it "has an edit link that takes you to the edit page" do
        page.should have_content('Edit Store')
        # click_link_or_button('Edit Store')
      end

      it "takes you to the edit page when you click the edit store link" do
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