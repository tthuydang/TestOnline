class CreateSubtickets < ActiveRecord::Migration[6.0]
  def change
    create_table :subtickets do |t|
      t.string :code
      t.string :content
      t.references :ticket, null: false, foreign_key: true

      t.timestamps
    end
  end
end
