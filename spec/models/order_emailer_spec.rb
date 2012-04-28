require 'spec_helper'

describe 'Order Emailer' do
  context "self.perform" do
    it "calls the order-mailer to send mail", :model => :bj do
      order = double("order")
      user = double("user")
      User.stub(:find).with(1).and_return(user)
      Order.stub(:find).with(2).and_return(order)
      mailer = double("string")
      UserMailer.should_receive(:order_confirmation).with(user, order).and_return(mailer)
      mailer.should_receive(:deliver)
      OrderEmailer.perform(1, 2, User.to_s)
    end
  end
end