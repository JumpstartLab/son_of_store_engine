class StoreChangeStorePathToSlug < ActiveRecord::Migration
  def change
    rename_column :stores, :path, :slug
  end
end
