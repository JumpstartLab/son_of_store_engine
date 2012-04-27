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
end