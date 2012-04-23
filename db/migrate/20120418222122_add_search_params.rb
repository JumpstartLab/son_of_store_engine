class AddSearchParams < ActiveRecord::Migration
  def change
    add_column :searches, :date, :date
    add_column :searches, :total, :integer
    add_column :searches, :t_sym, :string
    add_column :searches, :d_sym, :string
    add_column :searches, :email, :string
    add_column :searches, :status, :string
    add_column :searches, :title, :string
  end
end
