class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.integer :active, :default => 1

      t.timestamps
    end
  end
end
