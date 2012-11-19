class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :url_name
      t.string :description
      t.boolean :approved, :default => false
      t.boolean :enabled, :default => false

      t.timestamps
    end
  end
end
