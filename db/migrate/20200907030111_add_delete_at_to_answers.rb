class AddDeleteAtToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :delete_at, :timestamp
  end
end
