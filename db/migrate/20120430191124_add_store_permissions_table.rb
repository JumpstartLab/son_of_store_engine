class AddStorePermissionsTable < ActiveRecord::Migration
  def change
    create_table :store_permissions do |t|
      t.integer :user_id
      t.integer :store_id
      t.integer :permission_level
    end
  end
end
