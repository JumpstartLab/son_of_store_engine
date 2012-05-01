class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.integer :price
      t.string :photo
      t.boolean :retired, :default => false
      t.integer :store_id

      t.timestamps
    end

    add_index :products, :store_id
    add_index :products, :title
    add_index :products, :retired
    add_index :products, [:store_id, :retired]
  end
end
