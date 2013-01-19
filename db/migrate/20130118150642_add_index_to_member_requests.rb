class AddIndexToMemberRequests < ActiveRecord::Migration
  def change
    add_index :member_requests, :user_id
    add_index :member_requests, :group_id
  end
end
