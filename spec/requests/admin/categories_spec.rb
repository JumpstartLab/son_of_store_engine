require 'spec_helper'

describe "As an admin updating categories" do
  def set_host(sub)
    Capybara.default_host = "#{sub}.example.com" #for Rack::Test
    Capybara.app_host = "http://#{sub}.127localhost.com:6543"
  end

  let!(:user) { FactoryGirl.create(:user, :admin => true) }
  let!(:store) { FactoryGirl.create(:store,
                                   :name => "Test Store",
                                   :url_name => "test-store",
                                   :description => "errday im testin",
                                   :approved => true,
                                   :enabled => true) }

  before(:each) do
    login_user_post(user.email, "foobar")
    visit store_path(store)
  end

  context "when I'm creating a new category" do

    let(:category) { FactoryGirl.build(:category) }
    before(:each) do
      set_host("best-sunglasses")
      visit new_admin_category_path
    end

    context "and I enter invalid information" do
      it "prevents me from making a new category" do
        save_and_open_page
        expect {click_link_or_button('Create Category')}.to_not change(Category, :count).by(1)
      end

      it "shows me some error message" do
        click_link_or_button('Create Category')
        page.should have_selector('div.alert.alert-error')
      end
    end

    context "and I enter valid information" do
      before do
        fill_in "Name", with: category.name
      end

      it "successfully creates a category" do
        expect {click_link_or_button('Create Category')}.to change(Category, :count).by(1)
      end
    end
  end

  context "when I'm updating a category" do
    let(:category) { FactoryGirl.create(:category) }
    before(:each) {visit edit_admin_category_path(store, category)}

    context "when I pass valid attributes" do
      it "updates the category" do
        fill_in "Name", with: "sweet"
        click_link_or_button('Update Category')
        new_category = Category.find(category.id)
        new_category.name.should == "sweet"
      end
    end

    context "when I pass invalid attributes" do
      it "doesn't update the category" do
        fill_in "Name", with: ""
        click_link_or_button('Update Category')
        category.name.should_not == ""
      end
    end
  end
end
