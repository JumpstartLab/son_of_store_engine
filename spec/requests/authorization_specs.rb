require 'spec_helper'

  describe "As a visitor" do
    context "and I do things I'm not supposed to do" do

      it "won't let me on to the admin pages unless I'm logged in" do
        visit "/admin/stores"
        page.should have_content "Sign in"
      end

      # it "won't let me view a store that not enabled" do

      # end

    end
  end

  describe "As a user" do
    context "and I do things I'm not supposed to do" do
      let(:user) { FactoryGirl.create(:user) }

      it "won't let me view the super admin dashboard" do
        visit "/admin/stores"
        fill_in "email", with: user.email
        fill_in "password", with: "foobar"
        click_link_or_button('Log in')
        page.should_not have_content ("Super Admin")
      end
    end
  end

  describe "As a store_admin" do

  end

  describe "As a store_stocker" do

  end

  describe "As a super_admin" do

  end