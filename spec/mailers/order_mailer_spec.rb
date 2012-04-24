require "spec_helper"

describe OrderMailer do
  let!(:user){ FactoryGirl.create(:user, id: 1) }
  let!(:order_products) do
    [].tap do |ary|
      4.times { ary << FactoryGirl.create(:order_product) }
    end
  end
  let!(:order){ FactoryGirl.create(:order, order_products: order_products) }
  let(:mail){ OrderMailer.order_confirmation(order) }
  describe "#order_confirmation" do
    it "sends an email" do
      mail.deliver
      ActionMailer::Base.deliveries.last.should == mail
    end
  end
end
