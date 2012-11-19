require 'spec_helper'

describe "Background Job", :bj => :emails do
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

  context ".store_approved_email" do
    it "queues the store approved emailer in resque" do
      store = double("store", :id => 1)
      Resque.should_receive(:enqueue).with(StoreApprovedEmailer, 1)
      BackgroundJob.store_approved_email(store)
    end
  end

  context ".store_declined_email" do
    it "queues the store declined emailer in resque" do
      user = double("user", :id => 1)
      store = double("store", :name => "Name", :description => "desc",
                    :slug => "slug", :owner => user)
      Resque.should_receive(:enqueue).with(StoreDeclinedEmailer, 1, store.name,
                                           store.description, store.slug)
      BackgroundJob.store_declined_email(store)
    end
  end
end
