class AddDeleteAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :delete_at, :timestamp
  end
end
