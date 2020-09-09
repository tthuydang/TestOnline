class AddDeleteAtToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :delete_at, :timestamp
  end
end
