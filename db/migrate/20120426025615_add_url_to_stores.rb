class AddUrlToStores < ActiveRecord::Migration
  def change
    add_column :stores, :url, :string
  end
end
