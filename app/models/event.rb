class Event < ActiveRecord::Base
  belongs_to :group
  has_many :comments, dependent: :destroy
  has_many :user_events, dependent: :destroy, order: :updated_at
  has_many :users, :through => :user_events

  validates :title, :presence => true,
                   :length => { :maximum => 32 }

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
end
