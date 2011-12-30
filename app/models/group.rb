class Group < ActiveRecord::Base
  has_many :events
  has_many :user_groups
  has_many :users, :through => :user_groups

  def owner
    User.find_by_id(owner_user_id) # 例外を発生させない
  end

  def owner=(user)
    self.owner_user_id = user.id
  end

  def member?(user)
    !!(user and users.find_by_id(user.id))
  end
end
