# == Schema Information
#
# Table name: stores
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  slug        :string(255)
#  description :string(255)
#  status      :string(255)     default("pending")
#  css         :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
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

  it "has a slug attribute" do
    store.should respond_to(:slug)
  end

  it 'properly parameterizes slug' do
    s = Fabricate(:store, :name => 'first store', :slug => 'first store')
    s.slug.should == 'first-store'
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
                            slug: "example-store",
                            description: "example store") }
    it "is not saved as valid" do
      store.save.should be_false
    end
  end

  context "when a store without a unique store id is created" do
    let(:store) { Store.new(name: "Example Store",
                        slug: nil,
                        description: "example store") }
    it "is not saved as valid" do
      store.save.should be_false
    end
  end

  context "when a store without a description is created" do
    let(:store) { Store.new(name: "Example Store",
                        slug: "example-store",
                        description: nil) }
    it "is not saved as valid" do
      store.save.should be_false
    end
  end

  context "when a store name already exists in the database" do
    let(:original) { Store.new(name: "Example Store",
                               slug: "example-store",
                               description: "example store") }
    let(:new_store_2) { Store.new(name: "Example Store",
                                  slug: "the-second-store",
                                  description: "example store") }
    let(:new_store_3) { Store.new(name: "example store",
                                  slug: "the-third-store",
                                  description: "example store") }
    let(:new_store_4) { Store.new(name: "EXAMPLE STORE",
                                  slug: "the-fourth-store",
                                  description: "example store") }
    it "a store with the same name cannot saved" do
      original.save
      new_store_2.save.should be_false
      new_store_3.save.should be_false
      new_store_4.save.should be_false
    end
  end

  context "when a slug already exists in the database" do
    let(:original) { Store.new(name: "Example Store",
                               slug: "example-store",
                               description: "example store") }
    let(:new_store_2) { Store.new(name: "The Second Store",
                                  slug: "Example-Store",
                                  description: "example store") }
    let(:new_store_3) { Store.new(name: "The Third Store",
                                  slug: "EXAMPLE-STORE",
                                  description: "example store") }
    let(:new_store_4) { Store.new(name: "The Fourth Store",
                                  slug: "example-store",
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
                                        slug: "example-store",
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
                                       slug: "example-store",
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

  context "when a user is added as a new admin to the store" do
    let! (:admin_user) { Fabricate(:admin_user) }
    let! (:store) { Fabricate(:store, :users => [admin_user]) }

    it "emails user" do
      mailer = double("string")
      StoreAdminMailer.stub(:new_admin_email).with(admin_user, store).and_return mailer
      mailer.should_receive(:deliver)
      store.add_admin_from_form(admin_user.email)
    end
  end

  # context "when a user is removed as an admin from the store" do
  #   let (:admin_user) { Fabricate(:admin_user) }
  #   let (:second_admin_user) { Fabricate(:admin_user) }
  #   let (:store) { Fabricate(:store, :users => [admin_user]) }

  #   it "emails user" do
  #     mailer = double("string")
  #     StoreAdminMailer.stub(:delete_admin_email).with(admin_user, store).and_return mailer
  #     mailer.should_receive(:deliver)
  #     store.delete_admin_user(admin_user.id)
  #   end
  # end

  context "when a non-sonofstoreengine user is added as a store admin" do
    let (:email) { "wazootyman@wazootyman.com" }
    let! (:store) { Fabricate(:store) }

    it "emails user" do
      mailer = double("string")
      StoreAdminMailer.stub(:invite_admin_email).with(email, store).and_return mailer
      mailer.should_receive(:deliver)
      store.invite_new_admin(email)
    end
  end

end
