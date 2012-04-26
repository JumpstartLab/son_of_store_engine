require 'spec_helper'

describe "Background Job" do
  context ".order_emailer", :model => :bj do
    it "queues the order emailer in resque" do
      order = double("order")
      user = double("user")
      Resque.should_receive(:enqueue).with(OrderEmailer, user,order)
      BackgroundJob.order_email(user, order)
    end
  end
end