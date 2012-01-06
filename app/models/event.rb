class Event < ActiveRecord::Base
  belongs_to :group
  has_many :user_events
  has_many :users, :through => :user_events
  def atnds(*args) user_events(*args) end

  def attendees
    user_events.find(:all, :conditions => { :state => 'attendance' }).map(&:user)
  end

  def maybees
    user_events.find(:all, :conditions => { :state => 'maybe' }).map(&:user)
  end

  def absentees
    user_events.find(:all, :conditions => { :state => 'absence' }).map(&:user)
  end
end
