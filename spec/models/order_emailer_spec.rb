require 'spec_helper'

describe 'Order Emailer' do
  context "self.perform" do
    it "calls the order-mailer to send mail", :model => :bj do
      order = double("order")
      user = double("user")

      mailer = double("string")
      UserMailer.should_receive(:order_confirmation).with(user,order).and_return(mailer)
      mailer.should_receive(:deliver)
      OrderEmailer.perform(user, order)
    end
  end
end