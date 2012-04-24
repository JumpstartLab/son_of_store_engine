class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :path

      t.timestamps
    end

    add_index :stores, :path
  end
end
