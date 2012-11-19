#
class StoreAdmin::UsersController < ApplicationController
  before_filter :require_admin
  before_filter :lookup_user, only: :show

  def index
    @users = User.all
  end

  def show
  end

  private

  def lookup_user
    @user = User.find(params[:id])
  end

end
