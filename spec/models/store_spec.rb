require 'spec_helper'

describe Store, :model => :store do
  context "changing a store status" do
    let!(:store) { FactoryGirl.create(:store) }
    before { ActionMailer::Base.deliveries = [] }

    it "notifies the store owner via email when the store is approved" do
      store.approve!
      ActionMailer::Base.deliveries.first.subject.include?("approved").should be_true
      ActionMailer::Base.deliveries.first.body.include?("making some moolah").should be_true
    end

    it "notifies the store owner via email when the store is declined" do
      store.decline!  
      ActionMailer::Base.deliveries.first.subject.include?("declined").should be_true
      ActionMailer::Base.deliveries.first.body.include?("better idea").should be_true
    end
  end

  context "starting up a new store" do
    let!(:user) { FactoryGirl.create(:user) }
    it "does not allow a store to be created without an owner" do
      expect do
        Store.create!(name: "Foo", slug: "www.bar.com", owner_id: nil)
      end.should raise_error
    end

    it "allows a store to be created after validating presence of owner" do
      expect do
        Store.create!(name: "Foo", slug: "www.bar.com", owner_id: :user_id)
      end.should_not raise_error
    end

    it "does not allow creation of a store with already existing name" do
      Store.create!(name: "Foo", slug: "www.bar.com", owner_id: :user_id)
      expect do
        Store.create!(name: "Foo", slug: "www.barf.com", owner_id: :user_id)
      end.should raise_error
    end

    it "does not allow creation of a store with already existing name" do
      Store.create!(name: "Foo", slug: "www.bar.com", owner_id: :user_id)
      expect do
        Store.create!(name: "Fungus", slug: "www.bar.com", owner_id: :user_id)
      end.should raise_error
    end

    it "does not allow creation of a store with already existing name with 
        whitespace" do
      Store.create!(name: "Foo", slug: "www.bar.com", owner_id: :user_id)
      expect do
        Store.create!(name: "Foo  ", slug: "test.bar.com", owner_id: :user_id)
      end.should raise_error
    end

    it "does not allow creation of a slug with already existing slug with 
        whitespace" do
      Store.create!(name: "Foo", slug: "www.bar.com", owner_id: :user_id)
      expect do
        Store.create!(name: "test ", slug: "www.bar.com  ", owner_id: :user_id)
      end.should raise_error
    end

    it "accepts the creation of new products" do
      shop = Store.create!(name: "Foo", slug: "www.bar.com", owner_id: :user_id)
      item = FactoryGirl.create(:product)
      shop.products << item
      shop.products.count.should == 1
    end
  end
end
