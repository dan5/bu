class User < ActiveRecord::Base
  class UnAuthorized < Exception ; end
  class NotAdministrator < Exception ; end

  validates :name, :presence => true,
                   :length => { :maximum => 16 }

  has_many :user_groups
  has_many :groups, :through => :user_groups
  has_many :user_events
  has_many :events, :through => :user_events

  def administrator?
    id == 1
  end

  def status
    'new'
  end

  def joinded_at(group)
    user_groups.find_by_group_id(group.id).created_at
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
      user.name = auth['info']['name']
    end
  end
end
