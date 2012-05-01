require 'spec_helper'

describe StorePermission do
  describe ".invite_user_to_be_admin_of(store, email)" do
    let!(:store) { Fabricate(:store) }

    it "creates a new store permission" do
      expect { StorePermission.invite_user_to_be_admin_of(store, "dweevil@zappa.com") }.to change{ StorePermission.count }.by(1)
    end
    it "creates a new store permission with a hex but no user id" do
      StorePermission.invite_user_to_be_admin_of(store, "frank@zappa.com")
      StorePermission.last.user_id.should be_nil
      StorePermission.last.admin_hex.should_not be_nil
    end
    it "emails the user" do
      pending "not sure how to test emails"
    end
  end
end# == Schema Information
#
# Table name: store_permissions
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  store_id         :integer
#  permission_level :integer
#  admin_hex        :string(255)
#

