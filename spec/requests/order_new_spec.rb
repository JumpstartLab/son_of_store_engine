require 'spec_helper'

# describe "Order New" do
#   let!(:store) do
#     FactoryGirl.create(:store)
#   end
#   before(:each) do
#     Capybara.app_host = "http://#{store.url}.son.test"
#   end
#   let!(:user) do
#     FactoryGirl.create(:user, :password => "mike", :stripe_id => "cus_WyPWX06WqQhlXo")
#   end 
#   let!(:products) do
#     (1..4).map { FactoryGirl.create(:product, :store => store)}
#   end
#   context "Generating a new order" do
#     before(:each) do
#       login(user)
#       products.each do |p|
#         visit product_path(p)
#         click_on "Add To Cart"
#       end      
#     end
#   end
# end