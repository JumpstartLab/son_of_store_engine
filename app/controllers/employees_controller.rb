class EmployeesController < ApplicationController
  
  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.promote(current_store, params[:role])
      notice = "Employee #{@user.full_name} has been hired!"
    else
      BackgroundJob.invitation_email(params[:email], params[:role], current_store)
      notice = "Employee #{params[:email]} has been invited!"
    end
    redirect_to store_dashboard_path(current_store), notice: notice
  end

  def new
  end

  def edit
    @employee = User.find(params[:id])
  end

  def update
    @employee = User.find(params[:id])
    @employee.promote(current_store, params[:role])
    notice = "Employee #{@employee.full_name} has been made a #{params[:role]}!"
    redirect_to store_dashboard_path(current_store), notice: notice
  end

  def destroy
    @employee = User.find(params[:id])
    @employee.terminate!(current_store)
    notice = "Employee #{@employee.full_name}'s employment has been terminated."
    redirect_to store_dashboard_path(current_store), notice: notice
  end
end