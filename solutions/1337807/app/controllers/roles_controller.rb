# Roles are used by CanCan to manage authorization
class RolesController < ApplicationController
  load_and_authorize_resource

  def index
    @roles = Role.all
  end

  def show
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(params[:role])

    if @role.save
      redirect_to roles_path, :notice => "Role #{@role.name} created."
    else
      render :new
    end
  end

  def edit
    @role = Role.find(params[:id])
  end

  def update
    @role = Role.find(params[:id])

    if @role.update_attributes(params[:role])
      redirect_to roles_path, :notice => "Role #{@role.name} updated."
    else
      render :edit
    end
  end
end
