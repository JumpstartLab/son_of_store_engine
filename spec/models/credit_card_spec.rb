require 'spec_helper'

describe CreditCard do
  let(:user)  { FactoryGirl.create(:user)  }
  let(:order) { FactoryGirl.create(:order, :user => user) }
  let(:credit_card) { FactoryGirl.create(:credit_card, :user => user) }

  context ".new" do
    it "should create a credit card attached to a user" do
      credit_card.user = user
      credit_card.user_id.should == user.id
    end

    it "should not save the credit card" do
      CreditCard.all.should be_empty
    end

    it "should require a user id" do
      CreditCard.new.save.should == false
    end
  end

  context "#formatted_last_four" do
    let(:credit_card) { FactoryGirl.create(:credit_card, :user => user) }

    it "should return a formatted last four digits" do
      credit_card.formatted_last_four.should == "XXXX-XXXX-XXXX-#{credit_card.last_four}"
    end
  end

  context "#formatted_exp_date" do
    it "should return a formatted expiration date" do
      credit_card.formatted_exp_date.should == "05/15"
    end
  end
end
