class CreatePrivileges < ActiveRecord::Migration
  def change
    create_table :privileges do |t|
      t.integer :user_id
      t.integer :store_id
      t.string :name

      t.timestamps
    end
  end
end
