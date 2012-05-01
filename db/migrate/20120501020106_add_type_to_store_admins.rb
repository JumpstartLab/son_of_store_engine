class AddTypeToStoreAdmins < ActiveRecord::Migration
  def change
    add_column :store_admins, :stocker, :boolean, default: true
  end
end
