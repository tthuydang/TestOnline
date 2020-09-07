class AddDeleteAtToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :delete_at, :timestamp
  end
end
