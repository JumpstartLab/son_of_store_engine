class CreateStoreUsers < ActiveRecord::Migration
  def change
    create_table :store_users do |t|
      t.integer :store_id
      t.integer :user_id

      t.timestamps
    end
  end
end
