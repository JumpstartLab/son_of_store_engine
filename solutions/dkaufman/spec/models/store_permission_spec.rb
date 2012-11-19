require 'spec_helper'

describe StorePermission do
  describe ".invite_user_to_be_admin_of(store, email)" do
    let!(:store) { Fabricate(:store) }
    let!(:store_permission) { Fabricate(:store_permission, store_id: store.id, user_id: nil, permission_level: 1) }
    let!(:store_permission_params) { { store_id: store_permission.store_id, permission_level: store_permission.permission_level } }

    it "creates a new store permission" do
      expect { StorePermission.invite_user_to_access_store(store_permission_params, "dweevil@zappa.com") }.to change{ StorePermission.count }.by(1)
    end
    it "creates a new store permission with a hex but no user id" do
      StorePermission.invite_user_to_access_store(store_permission_params, "frank@zappa.com")
      StorePermission.last.user_id.should be_nil
      StorePermission.last.admin_hex.should_not be_nil
    end
  end
  describe ".create_from_params_and_user" do
    let!(:store)  { Fabricate(:store) }
    let!(:user)   { Fabricate(:user) }
    let!(:params) { { store_id: store.id, permission_level: 1 } }
    
    it "creates a new store permission" do
      expect { StorePermission.create_from_params_and_user(params, user) }.to change{ StorePermission.count }.by(1)
    end
    it "creates a new store permission for the designated user" do
      StorePermission.create_from_params_and_user(params, user)
      user.is_admin_of(store).should be_true
    end
  end
end
# == Schema Information
#
# Table name: store_permissions
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  store_id         :integer
#  permission_level :integer
#  admin_hex        :string(255)
#

