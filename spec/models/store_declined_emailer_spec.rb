require 'spec_helper'

describe 'Store Declined Emailer', :bj => :declined do
  context "self.perform" do
    it "calls the store declined mailer to send mail" do
      store_name = "FooName"
      store_description = "Description"
      store_slug = "Slug"
      user = double("user", :id => 1)
      User.stub(:find).with(1).and_return(user)
      mailer = double("string")
      UserMailer.should_receive(:declined_store_notice).with(user, store_name, 
                               store_description, store_slug).and_return(mailer)
      mailer.should_receive(:deliver)
      StoreDeclinedEmailer.perform(1,store_name, store_description, store_slug)
    end
  end
end

