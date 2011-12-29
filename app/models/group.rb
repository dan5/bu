class Group < ActiveRecord::Base
  has_many :events

  def owner
    User.find(owner_user_id)
  end
end
