require 'spec_helper'

describe Privilege do
  context "given a store, a user privilege can be elevated" do
    it "allows role elevation of user to stocker" do
      shop = FactoryGirl.create(:store)
      user = FactoryGirl.create(:user)
      shop.set_privilege(user, "stocker")
      user.privileges.count.should == 1
      shop.privilege_for(user).name.should == "stocker"
    end
  end
end
