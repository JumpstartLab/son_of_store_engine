require 'spec_helper'

describe "Application Requests" do
  context "layout" do
    #context "user is admin" do
      it "should have a link to the order dashboard" do
        visit "/"
        page.should have_link("Dashboard", :href => orders_path)
        pending
      end
    #end
  end
end