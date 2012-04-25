require 'spec_helper'

describe "the admin stores page" do
  let(:admin) { FactoryGirl.create(:user, :admin => true) }
  let!(:store) { FactoryGirl.create(:store) }
  context "on the admin/stores page" do
    it "shows me all the stores in the system" do
      login(admin)
      visit admin_stores_path
      page.should have_content store.name
    end

    it "allows an admin to manipulate store status" do
      pending
    end
  end  

end