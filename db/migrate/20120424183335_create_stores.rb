class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.boolean :active, :default => false

      t.timestamps
    end
  end
end
