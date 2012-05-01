require 'spec_helper'


describe "Administrator store pages" do
  let!(:jq_admin_user) { FactoryGirl.create(:user, :admin => true) }
  # let!(:jq_admin_user) {
  #   user = User.new
  #   user.name = Faker::Internet.user_name
  #   user.email = Faker::Internet.email(user.name)
  #   user.display_name = user.name
  #   # user.password = "foobar"
  #   user.save
  # }
  let!(:test_two_store) { FactoryGirl.create(:store, :owner_id => jq_admin_user.id, :approved => true, :enabled => true) }

  before(:each) do
    test_two_store.add_admin(jq_admin_user)
    visit "/signout"
    visit "/sessions/new"
    fill_in "email", with: jq_admin_user.email
    fill_in "password", with: "foobar"
    click_link_or_button("Log in")
    # save_and_open_page
  end

  context "admin visits admin page page for store" do
    before (:each) do
      set_host("#{test_two_store.url_name}")
      visit admin_dashboard_path
    end

    it "has an edit link that takes you to the edit page" do
      page.should have_content('Edit Store Details')
    end

    context "editing store details" do
      before(:each) do
        click_link_or_button('Edit Store Details')
      end

      it "takes you to the edit page when you click the edit store link" do
        page.should have_selector('#edit')
      end

      describe "changing the name" do

        it "allows you to edit the name" do
          new_name = Faker::Internet.user_name
          fill_in "store_name", with: new_name
          click_link_or_button('Update Store')
          page.should have_content(new_name)
        end

        it "gives a flash message when you edit the name" do
          new_name = Faker::Internet.user_name
          fill_in "store_name", with: new_name
          click_link_or_button('Update Store')
          page.should have_selector('#alert')
          page.should have_content('was updated!')
        end

        it "does not find the old store name" do
          old_name = test_two_store.name
          new_name = Faker::Internet.user_name
          fill_in "store_name", with: new_name
          click_link_or_button('Update Store')
          page.should_not have_content old_name
        end
      end

      describe "changing the url_name" do

        it "includes the url_name form" do
          page.should have_selector("#edit_url")
        end

      end
    end
  end
end