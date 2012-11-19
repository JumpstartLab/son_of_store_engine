class StoreAdmin::UsersController < ApplicationController
  include ExtraUserMethods
  before_filter :require_admin
  before_filter :lookup_user, only: :show

  def index
    @users = User.all
  end

  def show
  end

end
