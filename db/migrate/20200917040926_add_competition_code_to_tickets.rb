class AddCompetitionCodeToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :competition_code, :string
  end
end
