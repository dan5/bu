class Group < ActiveRecord::Base
  class NotGroupMember < Exception ; end
  class NotGroupOwner < Exception ; end

  has_many :events
  has_many :user_groups
  has_many :users, :through => :user_groups

  def owner?(user)
    owner.id == user.id
  end
  
  def owner
    User.find_by_id(owner_user_id) # 例外を発生させない
  end

  def owner=(user)
    self.owner_user_id = user.id
  end

  def member?(user)
    !!(user and users.find_by_id(user.id))
  end

  def public?
    permission == 0
  end

  def secret?
    permission == 2
  end
end
