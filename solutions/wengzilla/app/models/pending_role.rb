class PendingRole < ActiveRecord::Base

  TYPES = %w{ store_stocker store_admin site_admin }

  attr_accessible :email, :name, :store

  belongs_to :role
  belongs_to :store

  def self.add_pending_role(store, params)
    role_name = params[:role]
    email = params[:user][:email]

    if User::PROMOTE.include? role_name
      pending_role = PendingRole.create(email: email, store: store, name: role_name)
    end
  end

end