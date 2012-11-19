class AddDescriptionToTheStore < ActiveRecord::Migration
  def change
    add_column :stores, :description, :text
  end
end
