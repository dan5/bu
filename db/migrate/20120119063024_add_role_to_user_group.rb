class AddRoleToUserGroup < ActiveRecord::Migration
  def change
    add_column :user_groups, :role, :string
  end
end
