class Event < ActiveRecord::Base
  belongs_to :group
  has_many :user_events, dependent: :destroy
  has_many :users, :through => :user_events

  validates :title, :presence => true,
                   :length => { :maximum => 32 }

  def atnds(*args) user_events(*args) end

  def attendees
    user_events.where(:state => 'attendance').map(&:user)
  end

  def maybees
    user_events.where(:state => 'maybe').map(&:user)
  end

  def absentees
    user_events.where(:state => 'absence').map(&:user)
  end
end
