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
    user_events.joins(:event).where(:state => "attendance", "events.group_id" => group.id, "events.ended" => true, "events.canceled" => false).count
  end

  def absence_count(group)
    user_events.joins(:event).where("state != 'attendance' and events.group_id = ? and events.ended = ? and events.canceled? = ?", group.id, true, false).count
  end

  def administrator?
    id == 1
  end

  def status(group)
    'new user'
  end

  def role(group)
    user_group(group).role
  end

  def joinded_at(group)
    user_group(group).created_at
  end

  def user_group(group)
    user_groups.find_by_group_id(group.id)
  end

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

  # thx: http://d.hatena.ne.jp/kaorumori/20111113/1321155791
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.screen_name = auth['info']['nickname']
      #user.name = auth['info']['name']
      user.name = user.screen_name
    end
  end
end
