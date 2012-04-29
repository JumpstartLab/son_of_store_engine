require "spec_helper"

describe Admin do
  let!(:admin){ FactoryGirl.create(:user, :name => "worace", :email => "worace@worace.worace", :admin => true) }
  let!(:anon_email) { "pierre@worace.worace"}
  let!(:store) { Store.last }

  let(:mail){ AdminMailer.request_admin_signup(admin) }
  let(:mail2){ AdminMailer.request_admin_signup(admin) }

  describe "#signup_confirmation" do
    it "sends an email" do
      mail.deliver
      ActionMailer::Base.deliveries.last.should == mail
    end

    it "sent to the correct email address" do
      mail.deliver
      ActionMailer::Base.deliveries.last.to.should == [user.email]
    end

    it "has the correct subject" do
      mail.deliver
      ActionMailer::Base.deliveries.last.subject.should == "Welcome to Store Engine!"
    end
  end
end