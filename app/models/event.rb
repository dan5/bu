# coding: utf-8
class Event < ActiveRecord::Base
  class NotEventOwner < Exception ; end
  class NotEventManager < Exception ; end

  belongs_to :group

  has_many :comments, dependent: :destroy
  has_many :user_events, dependent: :destroy, order: :updated_at
  has_many :users, :through => :user_events

  validates :title,   presence: true,
                      length: { maximum:  32 }
  validates :place,   length: { maximum: 255 }
  validates :address, length: { maximum: 255 }
  validates :limit,   numericality: { greater_than_or_equal_to:    1,
                                      less_than_or_equal_to:    1000 }

  def img
    src = image_src
    src = group.image_src if src.empty?
    src = 'rails.png' if src.empty?
    src
  end

  def image_src
    image_url.to_s.gsub(/['"<>]/, '')
  end

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

  #def absences
  #  user_events.where(:state => 'absence')
  #end

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

  def cancel
    update_attributes!(:canceled => true)
  end

  def be_active
    update_attributes!(:canceled => false)
  end

  def be_ended
    raise if ended?
    transaction do
      update_attributes!(:ended => true)

      waitings.each do |user_event| #なぜこの処理をしているのかよくわかりません
        user_event.state = 'absence'
        user_event.save!
      end

      group.users.each do |user| #なぜこの処理をしているのかよくわかりません
        next if user.user_events.find_by_event_id(self.id)
        user.user_events.create(:event_id => self.id, :state => 'no answer')
      end
    end
  end

  def self.be_ended_all
    t = Time.now
    events = where("started_at < ? and ended_at < ? and ended = ?", t, t, false)
    events.each(&:be_ended)
  end
end
