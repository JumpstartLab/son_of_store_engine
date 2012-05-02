class AddUrlToStore < ActiveRecord::Migration
  def change
    add_column :stores, :photo_url, :string
  end
end
