class StoreAdminController < ApplicationController
  before_filter :require_admin
end