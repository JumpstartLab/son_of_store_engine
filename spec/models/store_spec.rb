# == Schema Information
#
# Table name: stores
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  store_unique_id :string(255)
#  description     :string(255)
#  status          :string(255)     default("pending")
#  user_id         :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#


require 'spec_helper'

describe Store do
  after(:all) do
    Store.destroy_all
  end

  let!(:store) { Fabricate(:store) }

  it "has a name attribute" do
    store.should respond_to(:name)
  end

  it "has a store_unique_id attribute" do
    store.should respond_to(:store_unique_id)
  end

  it 'properly parameterizes store_unique_id' do
    s = Fabricate(:store, :name => 'first store', :store_unique_id => 'first store')
    s.store_unique_id.should == 'first-store'
  end

  it "has a description attribute" do
    store.should respond_to(:description)
  end

  it "has a status attribute" do
    store.should respond_to(:status)
  end

  it "has a pending? method" do
    store.should respond_to(:pending?)
  end

  it "has an active? method" do
    store.should respond_to(:active?)
  end

  it "has a retired_products method" do
    store.should respond_to(:retired_products)
  end

  context "when a store without a name is created" do
    let(:store) { Store.new(name: nil,
                            store_unique_id: "example-store",
                            description: "example store") }
    it "is not saved as valid" do
      store.save.should be_false
    end
  end

  context "when a store without a unique store id is created" do
    let(:store) { Store.new(name: "Example Store",
                        store_unique_id: nil,
                        description: "example store") }
    it "is not saved as valid" do
      store.save.should be_false
    end
  end

  context "when a store without a description is created" do
    let(:store) { Store.new(name: "Example Store",
                        store_unique_id: "example-store",
                        description: nil) }
    it "is not saved as valid" do
      store.save.should be_false
    end
  end

  context "when a store name already exists in the database" do
    let(:original) { Store.new(name: "Example Store",
                               store_unique_id: "example-store",
                               description: "example store") }
    let(:new_store_2) { Store.new(name: "Example Store",
                                  store_unique_id: "the-second-store",
                                  description: "example store") }
    let(:new_store_3) { Store.new(name: "example store",
                                  store_unique_id: "the-third-store",
                                  description: "example store") }
    let(:new_store_4) { Store.new(name: "EXAMPLE STORE",
                                  store_unique_id: "the-fourth-store",
                                  description: "example store") }
    it "a store with the same name cannot saved" do
      original.save
      new_store_2.save.should be_false
      new_store_3.save.should be_false
      new_store_4.save.should be_false
    end
  end

  context "when a store_unique_id already exists in the database" do
    let(:original) { Store.new(name: "Example Store",
                               store_unique_id: "example-store",
                               description: "example store") }
    let(:new_store_2) { Store.new(name: "The Second Store",
                                  store_unique_id: "Example-Store",
                                  description: "example store") }
    let(:new_store_3) { Store.new(name: "The Third Store",
                                  store_unique_id: "EXAMPLE-STORE",
                                  description: "example store") }
    let(:new_store_4) { Store.new(name: "The Fourth Store",
                                  store_unique_id: "example-store",
                                  description: "example store") }
    it "a store with the same name should cannot saved" do
      original.save
      new_store_2.save.should be_false
      new_store_3.save.should be_false
      new_store_4.save.should be_false
    end
  end

  context "when the store has a status of 'pending'" do

    let!(:pending_store) { Store.create(name: "Example Store", 
                                        store_unique_id: "example-store",
                                        description: "example store",
                                        status: "pending") }

    it "responds to the pending? method" do
      pending_store.pending?.should be_true
    end

    it "is contained within the set of 'pending' stores" do
      Store.where(:status => 'pending').should include(pending_store)
    end
  end

  context "when the store has a status of 'active'" do

    let!(:active_store) { Store.create(name: "Example Store", 
                                       store_unique_id: "example-store",
                                       description: "example store",
                                       status: "active") }

    it "it responds to the active? method" do
      active_store.active?.should be_true
    end

    it "is contained within the set of 'active' stores" do
      Store.where(:status => 'active').should include(active_store)
    end
  
    context "and it has retired products" do
      let(:product) { Fabricate(:product, :store => store) }
      let(:retired_product) { Fabricate(:product, :store => store, :retired => true) }

      it "has a retired_products class method that returns all of the stores retired prodcuts" do
        store.retired_products.should include(retired_product)
      end
    end
  end
end
