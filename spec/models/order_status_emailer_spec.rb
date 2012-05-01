require 'spec_helper'

describe 'Order Status Emailer', :bj => :status do
  context "self.perform" do
    it "calls the order status mailer to send mail" do
      order = double("order")
      user = double("user")
      User.stub(:find).with(1).and_return(user)
      Order.stub(:find).with(2).and_return(order)
      mailer = double("string")
      UserMailer.should_receive(:status_confirmation).with(user, order).and_return(mailer)
      mailer.should_receive(:deliver)
      OrderStatusEmailer.perform(1, 2, User.to_s)
    end
  end
end
