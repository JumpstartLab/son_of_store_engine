class AddEnabledToStore < ActiveRecord::Migration
  def change
    add_column :stores, :enabled, :boolean
    add_column :stores, :description, :text
  end
end
