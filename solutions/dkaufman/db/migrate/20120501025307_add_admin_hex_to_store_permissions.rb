class AddAdminHexToStorePermissions < ActiveRecord::Migration
  def change
    add_column :store_permissions, :admin_hex, :string
  end
end
