class Event < ActiveRecord::Base
  class NotEventOwner < Exception ; end
  class NotEventManager < Exception ; end

  belongs_to :group
  has_many :comments, dependent: :destroy
  has_many :user_events, dependent: :destroy, order: :updated_at
  has_many :users, :through => :user_events

  validates :title, :presence => true,
                   :length => { :maximum => 32 }

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
    return true if group.manager?(user)
  end

  def attendances
    user_events.where(:state => 'attendance')
  end

  def waitings
    attendances - attendances.limit(limit)
  end

  def attendees
    attendances.limit(limit).map(&:user)
  end

  def waiting_attendees
    waitings.map(&:user)
  end

  def maybees
    user_events.where(:state => 'maybe').map(&:user)
  end

  def absentees
    user_events.where(:state => 'absence').map(&:user)
  end

  def be_ended
    raise if ended?
    transaction do
      update_attributes(:ended => true)

      waitings.each do |user_event|
        user_event.state = 'absence'
        user_event.save
      end

      group.users.each do |user|
        next if user.user_events.find_by_event_id(self.id)
        user.user_events.create(:event_id => self.id, :state => 'no answer')
      end
    end
  end

  def self.be_ended_all
    events = where("ended_at < ? and ended = ?", Time.now, false)
    events.each &:be_ended
  end
end
