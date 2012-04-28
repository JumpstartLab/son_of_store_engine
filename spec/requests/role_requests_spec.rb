require 'spec_helper'

describe Role do
  let(:user) { Fabricate(:user) }
  let(:role) { Fabricate(:role) }

  it "can be viewed on a user show page" do
    user.roles << role
    visit user_path(user)
    page.should have_content(role.type)
  end

  it "can be created by superadmins" do
    role.type = 'super_admin'
    user.roles << role
    login_as(user)
    visit new_role_path
    page.should have_content('New Role')
    page.should_not have_content('Access denied.')
    fill_in 'Type', :with => 'sassy_pants'
    expect { click_button 'Submit' }.to change{ Role.count }.from(1).to(2)
  end

  it "can't be created by non-superadmins" do
    role.type = 'admin'
    user.roles << role
    login_as(user)
    visit new_role_path
    page.should_not have_content('New Role')
    page.should have_content('Access denied.')
  end

  it "can't be created without signing in" do
    visit new_role_path
    page.should_not have_content('New Role')
    page.should have_content('Access denied.')
  end

  it "can be edited by superadmins" do
    role.type = 'super_admin'
    user.roles << role
    login_as(user)
    visit edit_role_path
    page.should have_content('Edit Role')
    page.should_not have_content('Access denied.')
    fill_in 'Type', :with => 'sassy_pants'
    expect { click_button 'Submit' }.to change{ Role.count }.from(1).to(2)
  end

  it "can't be edited by non-superadmins" do
    role.type = 'admin'
    user.roles << role
    login_as(user)
    visit edit_role_path
    page.should_not have_content('New Role')
    page.should have_content('Access denied.')
  end

  it "can't be edited without signing in" do
    role.type = 'admin'
    user.roles << role
    login_as(user)
    visit edit_role_path
    page.should_not have_content('New Role')
    page.should have_content('Access denied.')
  end

  it "can be assigned to a user in the system by a superadmin editing a user" do
    role.type = 'super_admin'
    user.roles << role
    role2 = Role.create(:type => 'fancy_pants')
    login_as(user)
    visit edit_user_path
    page.should have_content('Fancy Pants')
    check('Fancy Pants')
    click_button('Update user')
    page.should have_content("#{user.name} updated with role #{role2}")
  end
end
