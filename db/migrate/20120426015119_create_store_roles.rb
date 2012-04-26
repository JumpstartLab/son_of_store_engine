class CreateStoreRoles < ActiveRecord::Migration
  def change
    create_table :store_roles do |t|
      t.integer :user_id
      t.integer :store_id
      t.integer :permission, :default => 9

      t.timestamps
    end
  end
end
