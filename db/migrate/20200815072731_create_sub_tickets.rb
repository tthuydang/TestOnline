class CreateSubTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :sub_tickets do |t|
      t.string :code
      t.text :content
      t.references :ticket, null: false, foreign_key: true

      t.timestamps
    end
  end
end
