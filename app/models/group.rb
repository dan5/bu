class Group < ActiveRecord::Base
  class NotGroupOwner < Exception ; end
  class NotGroupManager < Exception ; end
  class NotGroupMember < Exception ; end

  validates :name, :presence => true,
                   :length => { :maximum => 16 }
  validates :summary, :presence => true,
                      :length => { :maximum => 100 }
  validates :description, :length => { :maximum => 4096 }

  has_many :events, dependent: :destroy, :order => 'started_at desc'
  has_many :posts, dependent: :destroy, :order => :created_at
  has_many :user_groups, dependent: :destroy
  has_many :users, :through => :user_groups

  def owner?(user)
    owner.id == user.id
  end
  
  def owner
    User.find(owner_user_id)
  rescue ActiveRecord::RecordNotFound
    User.new(:name => 'testman')
  end

  def owner=(user)
    self.owner_user_id = user.id
  end

  def manager?(user)
    return true if owner?(user)
    !!(user and user_groups.find_by_user_id(user.id).role?)
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
