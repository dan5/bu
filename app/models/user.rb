class User < ActiveRecord::Base
  class UnAuthorized < Exception ; end
  class NotAdministrator < Exception ; end

  validates :name, :presence => true,
                   :length => { :maximum => 16 }
  validates_uniqueness_of :uid, :scope => [:provider]

  has_many :comments, dependent: :destroy
  has_many :user_groups, dependent: :destroy
  has_many :groups, :through => :user_groups
  has_many :user_events, dependent: :destroy
  has_many :events, :through => :user_events
  has_many :member_requests, dependent: :destroy
  has_many :requested_groups, :source => :group, :through => :member_requests

  def attendance_count(group)
    joined_time = user_groups.find_by_group_id(group.id).created_at
    user_events.joins(:event).where(:state => "attendance", "events.group_id" => group.id, "events.ended" => true, "events.canceled" => false).where("events.started_at > ?", joined_time).count
  end

  def absence_count(group)
    joined_time = user_groups.find_by_group_id(group.id).created_at
    user_events.joins(:event).where("state != 'attendance' and events.group_id = ? and events.ended = ? and events.canceled = ? and events.started_at > ?", group.id, true, false, joined_time).count
  end

  def administrator?
    id == 1
  end

  def img
    image or 'twitter-icon.png'
  end

  def status(group)
    'new user'
  end

  def role(group)
    user_group(group).role
  end

  def user_group(group)
    user_groups.find_by_group_id(group.id)
  end

  def atnd(event)
    user_events.find_by_event_id(event.id)
  end

  def attend(event)
    events << event
    user_events.find_by_event_id(event.id).update_attributes!(:state => 'attendance')
  end

  def be_absent(event)
    events << event
    user_events.find_by_event_id(event.id).update_attributes!(:state => 'absence')
  end

  def be_maybe(event)
    events << event
    atnd(event).update_attributes!(:state => 'maybe')
  end

  def self.find_or_create_with_omniauth(auth)
    find_by_provider_and_uid(auth['provider'], auth['uid']) || create_with_omniauth(auth)
  end

  private
  def self.create_with_omniauth(auth)
    create do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.name = auth['info']['nickname']
      user.image = auth["info"]["image"]
      user.screen_name = auth['info']['nickname']
    end
  end
end
