class ChangeCompletedTimeTypeForHistories < ActiveRecord::Migration[6.0]
  def change
    change_column :histories, :completed_time, :string
  end
end
