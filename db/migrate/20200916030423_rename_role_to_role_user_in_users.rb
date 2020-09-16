class RenameRoleToRoleUserInUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column "users", "role", "role_user"
  end
end
