class AddDeleteAtToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :delete_at, :timestamp
  end
end
