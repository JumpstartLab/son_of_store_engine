require "spec_helper"

describe OrderMailer do
  let!(:user){ FactoryGirl.create(:user) }
  let!(:order_products) do
    [].tap do |ary|
      4.times { ary << FactoryGirl.create(:order_product) }
    end
  end
  let!(:order){ FactoryGirl.create(:order, order_products: order_products, user_id: user.id) }
  let(:mail){ OrderMailer.order_confirmation(order) }
  describe "#order_confirmation" do
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
      url = "localhost:3000/#{user.id.to_s}/orders/#{order.id.to_s}"
      ActionMailer::Base.deliveries.last.subject.should == "Order Confirmation"
    end
  end
end
