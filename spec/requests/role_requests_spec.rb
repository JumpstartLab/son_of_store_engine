require 'spec_helper'

describe Role do
  let(:store) { Fabricate(:store) }
  let(:user) { Fabricate(:user) }
  let(:role) { Fabricate(:role) }

  it "can be viewed by a super admin on a user edit page" do
    user.roles << role
    login_as_superadmin(user)
    visit edit_user_path(user)
    page.should have_content(role.name)
  end

  describe "superadmins" do
    before(:each) do
      role.update_attributes(:name => 'super_admin')
      user.roles << role
      login_as(user)
    end

    it "can create roles" do
      visit new_role_path
      page.should have_content('New Role')
      page.should_not have_content('You are not authorized to access this page.')
      fill_in 'Name', :with => 'sassy_pants'
      expect { click_button 'Create Role' }.to change{ Role.count }.from(1).to(2)
    end

    it "can edit roles" do
      visit edit_role_path(role)
      page.should have_content('Edit Role')
      page.should_not have_content('You are not authorized to access this page.')
      fill_in 'Name', :with => 'sassy_pants'
      click_button('Update Role')
      role.reload
      page.should have_content("Role #{role.name} updated.")
      role.name.should == 'sassy_pants'
    end

    it "can assign roles to a user when editing that user" do
      role2 = Role.create(:name => 'fancy_pants')
      visit edit_user_path(user, store)
      page.should have_content(role2.name)
      check(role2.name)
      click_button('Update User')
      page.should have_content("#{user.name} updated successfully.")
      user.roles.should include role2
    end

    it "sees a user's assigned roles when editing that user"
  end

  describe "non-superadmins" do
    before(:each) do
      role.update_attributes(:name => 'admin')
      user.roles << role
      login_as(user)
    end

    it "can't create roles" do
      visit new_role_path
      page.should_not have_content('New Role')
      page.should have_content('You are not authorized to access this page.')
    end

    it "can't edit roles" do
      visit edit_role_path(role)
      page.should_not have_content('Edit Role')
      page.should have_content('You are not authorized to access this page.')
    end
  end

  it "can't be created without signing in" do
    visit new_role_path
    page.should_not have_content('New Role')
    page.should have_content('You are not authorized to access this page.')
  end

  it "can't be edited without signing in" do
    visit edit_role_path(role)
    page.should_not have_content('Edit Role')
    page.should have_content('You are not authorized to access this page.')
  end
end
