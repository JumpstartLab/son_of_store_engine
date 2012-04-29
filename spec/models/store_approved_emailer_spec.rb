require 'spec_helper'

describe 'Store Approved Emailer', :bj => :approved do
  context "self.perform" do
    it "calls the store approved mailer to send mail" do
      store = double("store", :id => 1)
      Store.stub(:find).with(1).and_return(store)
      mailer = double("string")
      UserMailer.should_receive(:approved_store_notice).with(store).and_return(mailer)
      mailer.should_receive(:deliver)
      StoreApprovedEmailer.perform(1)
    end
  end
end
