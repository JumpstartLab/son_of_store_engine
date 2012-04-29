require "spec_helper"

describe Admin do
  let!(:admin){ FactoryGirl.create(:user, :name => "worace", :email => "worace@worace.worace", :admin => true) }
  let!(:anon_email) { "pierre@worace.worace"}
  let!(:store) { Store.last }

  let(:mail){ AdminMailer.new_admin_notification(admin.email, store.id) }
  let(:mail2){ AdminMailer.request_admin_signup(anon_email, store.id) }

  describe "#new_admin_notification" do
    it "sends an email" do
      mail.deliver
      ActionMailer::Base.deliveries.last.should == mail
    end

    it "sent to the correct email address" do
      mail.deliver
      ActionMailer::Base.deliveries.last.to.should == [admin.email]
    end

    it "has the correct subject" do
      mail.deliver
      ActionMailer::Base.deliveries.last.subject.should == "Invitation to help run #{store.name}"
    end
  end

    describe "#request_admin_signup" do
    it "sends an email" do
      mail2.deliver
      ActionMailer::Base.deliveries.last.should == mail2
    end

    it "sent to the correct email address" do
      mail2.deliver
      ActionMailer::Base.deliveries.last.to.should == [anon_email]
    end

    it "has the correct subject" do
      mail2.deliver
      ActionMailer::Base.deliveries.last.subject.should == "Invitation to help run #{store.name}"
    end
  end
end