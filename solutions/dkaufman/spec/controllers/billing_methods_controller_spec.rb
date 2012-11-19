require 'spec_helper'

describe BillingMethodsController do
  context "#index" do
    it "redirects to root" do
      get :index
      response.should redirect_to "/"
    end
  end
  
  context "#show" do
    it "redirects to root" do
      get :show
      response.should redirect_to "/"
    end
  end
end
