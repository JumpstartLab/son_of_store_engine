require 'spec_helper'

describe StoreAdmin::StorePermissionsController do
  context "#create" do
    it "redirects to root" do
      get :create
      response.should redirect_to "/"
    end
  end
end
