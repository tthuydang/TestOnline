class AddDetailsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :avatar, :string
    add_column :users, :type, :string
    add_column :users, :user_id, :integer
  end
end
