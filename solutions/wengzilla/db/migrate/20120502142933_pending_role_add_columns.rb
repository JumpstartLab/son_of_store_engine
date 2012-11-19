class PendingRoleAddColumns < ActiveRecord::Migration
  def change
    add_column :pending_roles, :name, :string
    add_column :pending_roles, :store_id, :integer
    remove_column :pending_roles, :role_id
  end
end
