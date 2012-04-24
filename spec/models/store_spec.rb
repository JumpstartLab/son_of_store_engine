require 'spec_helper'

describe Store do
  context "starting up a new store" do
    let!(:user) { FactoryGirl.create(:user) }
    it "does not allow a store to be created without an owner" do
      expect do
        Store.create!(name: "Foo", slug: "www.bar.com")
      end.should raise_error
    end
  
    it "allows a store to be created after validating presence of owner" do
      expect do
        Store.create!(name: "Foo", slug: "www.bar.com", owner_id: :user_id)
      end.should_not raise_error
    end

    it "accepts the creation of new products" do
    
    end
  end


end
