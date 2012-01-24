class AddOwnerUserIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :owner_user_id, :integer
  end
end
