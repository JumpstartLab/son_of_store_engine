require 'spec_helper'

describe StorePermission do
  describe ".invite_user_to_be_admin_of(store, email)" do
    let!(:user) { Fabricate(:user) }
    let!(:store) { Fabricate(:store) }

    it "creates a new store permission" do
      expect { StorePermission.invite_user_to_be_admin_of(store, email) }.to change{ StorePermission.count }.by(1)
    end
    it "emails the user" do
      pending "not sure how to test emails"
    end
  end
end