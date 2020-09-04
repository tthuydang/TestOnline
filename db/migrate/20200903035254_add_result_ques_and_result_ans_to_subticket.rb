class AddResultQuesAndResultAnsToSubticket < ActiveRecord::Migration[6.0]
  def change
    add_column :subtickets, :result_ques, :boolean
    add_column :subtickets, :result_ans, :boolean
  end
end
