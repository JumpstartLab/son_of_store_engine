require 'spec_helper'

describe "Background Job" do
  context ".order_emailer" do
    it "queues the order emailer in resque" do
      user = double("user", :id => 1)
      order = double("order", :id => 2)
      Resque.should_receive(:enqueue).with(OrderEmailer, 1, 2, user.class.to_s)
      BackgroundJob.order_email(user, order)
    end
  end

  context ".order_status_emailer" do
    it "queues the order status emailer in resque" do
      user = double("user", :id => 1)
      order = double("order", :id => 2)
      Resque.should_receive(:enqueue).with(OrderStatusEmailer, 1, 2, user.class.to_s)
      BackgroundJob.order_status_email(user, order)
    end
  end
end
