class RenameUrlToSlugInOrder < ActiveRecord::Migration
  def up
    rename_column :orders, :url, :slug
  end

  def down
    rename_column :orders, :slug, :url
  end
end
