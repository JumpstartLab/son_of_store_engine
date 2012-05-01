require 'spec_helper'

describe User do
  let(:test_user) { FactoryGirl.create(:user) }
  before(:each) do
    @attr = {
      full_name: "Chris Manderson",
      email: "chris@weddingsoon.com",
      username: "mandy",
      password: "1234",
      password_confirmation: "1234",
    }
  end

  it "should create a new instance of user given valid attributes" do
    User.create!(@attr)
  end
  
  it "doesn't allow assignment of admin" do
    expect do
      User.new(admin: true)
    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(full_name: ""))
    no_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(email: ""))
    no_email_user.should_not be_valid
  end

  it "has a valid email address"  do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "rejects invalid email address" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  describe "a user with username" do
    it "accepts a username of over 2 and under 32 characters" do
      username_user = User.new(@attr)
      username_user.should be_valid
    end

    it "rejects a username of under 2 characters" do
      invalid_username_user = User.new(@attr.merge(:username => 'p'))
      invalid_username_user.should_not be_valid
    end

    it "rejects a username of over 32 characters" do
      u = "u" * 33
      invalid_username_user = User.new(@attr.merge(:username => u))
      invalid_username_user.should_not be_valid
    end
  end

  describe "a user with a role" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:store) { FactoryGirl.create(:store) }

    it "acknowledges that owners may manage" do
      store.owner.may_manage?(store).should be_true
    end

    it "acknowledges that managers may manage" do
      user.promote(store, :manager)
      user.may_manage?(store).should be_true
    end

    it "acknolwedges that stockers may stock" do
      user.promote(store, :stocker)
      user.may_stock?(store).should be_true
    end

    it "indicates that stockers may not manage" do
      user.promote(store, :stocker)
      user.may_manage?(store).should be_false
    end

    it "indicates that unprivileged users may not stock" do
      user.may_stock?(store).should be_false
    end

    it "indicates that unprivileged users may not manage" do
      user.may_manage?(store).should be_false
    end    
  end

  describe "#places_of_employment", :model => :user do
    context "when user is employed" do
      it "returns stores that user can stock" do
        user = User.new
        priv1 = double("privilege", :store => "foo")
        priv2 = double("privilege", :store => "bar")
        privs = [priv1, priv2]
        user.stub(:privileges).and_return(privs)
        user.places_of_employment.should == ["foo", "bar"]
      end
    end
  end
end
