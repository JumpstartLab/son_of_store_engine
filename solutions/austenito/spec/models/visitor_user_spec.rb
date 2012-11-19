require 'spec_helper'

 describe VisitorUser, :model => :visitor_user do
   context "creating a user" do
     it "validates presence of email" do
       lambda { FactoryGirl.create(:visitor_user, :email => "") }.should raise_error
     end
   end
 end
