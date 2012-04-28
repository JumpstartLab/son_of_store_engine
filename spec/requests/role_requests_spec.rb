require 'spec_helper'

describe Role do
  let(:store) { Fabricate(:store) }
  let(:user) { Fabricate(:user) }
  let(:role) { Fabricate(:role) }

  it "can be viewed on a user edit page" do
    user.roles << role
    login_as(user)
    visit edit_user_registration_path(user)
    page.should have_content(role.name.capitalize)
  end

  it "can be created by superadmins" do
    role.update_attributes(:name => 'super_admin')
    user.roles << role
    login_as(user)
    visit new_role_path
    page.should have_content('New Role')
    page.should_not have_content('You are not authorized to access this page.')
    fill_in 'Name', :with => 'sassy_pants'
    expect { click_button 'Create Role' }.to change{ Role.count }.from(1).to(2)
  end

  it "can't be created by non-superadmins" do
    role.update_attributes(:name => 'admin')
    user.roles << role
    login_as(user)
    visit new_role_path
    page.should_not have_content('New Role')
    page.should have_content('You are not authorized to access this page.')
  end

  it "can't be created without signing in" do
    visit new_role_path
    page.should_not have_content('New Role')
    page.should have_content('You are not authorized to access this page.')
  end

  it "can be edited by superadmins" do
    role.update_attributes(:name => 'super_admin')
    user.roles << role
    login_as(user)
    visit edit_role_path(role)
    page.should have_content('Edit Role')
    page.should_not have_content('You are not authorized to access this page.')
    fill_in 'Name', :with => 'sassy_pants'
    click_button('Update Role')
    role.reload
    page.should have_content("Role #{role.name} updated.")
    role.name.should == 'sassy_pants'
  end

  it "can't be edited by non-superadmins" do
    role.update_attributes(:name => 'admin')
    user.roles << role
    login_as(user)
    visit edit_role_path(role)
    page.should_not have_content('New Role')
    page.should have_content('You are not authorized to access this page.')
  end

  it "can't be edited without signing in" do
    role.update_attributes(:name => 'admin')
    user.roles << role
    login_as(user)
    visit edit_role_path(role)
    page.should_not have_content('New Role')
    page.should have_content('You are not authorized to access this page.')
  end

  it "can be assigned to a user in the system by a superadmin editing a user" do
    role.update_attributes(:name => 'super_admin')
    user.roles << role
    role2 = Role.create(:name => 'fancy_pants')
    login_as(user)
    visit edit_user_registration_path(store)
    page.should have_content('Fancy pants')
    fill_password_to_update(user)
    check("role_#{role2.id}")
    click_button('Update My Account')
    page.should have_content("You updated your account successfully.")
    user.roles.should include role2
  end
end
