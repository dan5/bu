class AddIndexToUserEvents < ActiveRecord::Migration
  def change
    add_index :user_events, :user_id
    add_index :user_events, :event_id
  end
end
