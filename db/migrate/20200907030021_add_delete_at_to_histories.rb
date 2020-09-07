class AddDeleteAtToHistories < ActiveRecord::Migration[6.0]
  def change
    add_column :histories, :delete_at, :timestamp
  end
end
