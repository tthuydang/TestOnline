class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email
      t.string :password_digest
      t.string :avatar
      t.string :type
      t.integer :user_id

      t.timestamps
    end
  end
end
