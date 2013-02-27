class AddIndexToEvents < ActiveRecord::Migration
  def change
    add_index :events, :group_id
  end
end
