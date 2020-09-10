class CreateHistoryDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :history_details do |t|
      t.references :question, null: false, foreign_key: true
      t.references :answer, null: false, foreign_key: true
      t.references :history, null: false, foreign_key: true

      t.timestamps
    end
  end
end
