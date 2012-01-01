class User < ActiveRecord::Base
  class UnAuthorized < Exception ; end

  has_many :user_groups
  has_many :groups, :through => :user_groups
  has_many :user_events
  has_many :events, :through => :user_events
  def atnd(event)
    user_events.find_by_event_id(event.id)
  end

  def attend(event)
    events << event
    atnd(event).update_attributes :state => 'attendance'
  end

  def be_absent(event)
    events << event
    atnd(event).update_attributes :state => 'absence'
  end

  def be_maybe(event)
    events << event
    atnd(event).update_attributes :state => 'maybe'
  end
end
