class AddStartDateFinishDateToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :start_date, :timestamp
    add_column :tickets, :finish_date, :timestamp
  end
end
