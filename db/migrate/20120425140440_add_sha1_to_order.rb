class AddSha1ToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :sha1, :string
  end
end
