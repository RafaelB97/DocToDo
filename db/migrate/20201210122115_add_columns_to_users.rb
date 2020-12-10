class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    add_column :users, :lastName, :string
    add_column :users, :specialist, :string
  end
end
