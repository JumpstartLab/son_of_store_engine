class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :user_id
      t.string :role
      t.integer :store_id

      t.timestamps
    end
  end
end
