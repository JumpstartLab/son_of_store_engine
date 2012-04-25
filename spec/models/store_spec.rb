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

    it "accepts the creation of new products" do
      shop = Store.create!(name: "Foo", slug: "www.bar.com", owner_id: :user_id)
      item = FactoryGirl.create(:product)
      shop.products << item
      shop.products.count.should == 1
    end
  end


end
