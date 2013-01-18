class AddIndexToUserGroups < ActiveRecord::Migration
  def change
    add_index :user_groups, :user_id
    add_index :user_groups, :group_id
  end
end
