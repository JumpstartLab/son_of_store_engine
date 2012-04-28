require "spec_helper"

describe UserMailer do
  let!(:user){ FactoryGirl.create(:user) }

  let(:mail){ UserMailer.signup_confirmation(user) }

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
