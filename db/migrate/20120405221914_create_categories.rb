class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :product_category_id
      t.string :name
      t.integer :store_id

      t.timestamps
    end

    add_index :categories, :store_id
  end
end
