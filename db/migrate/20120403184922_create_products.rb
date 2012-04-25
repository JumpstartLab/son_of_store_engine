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
  end
end
