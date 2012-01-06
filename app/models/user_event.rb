class UserEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  validates_uniqueness_of :user_id, :scope => [:event_id]

  def state_level
    {
      'attendance' => 1,
      'maybe'      => 2,
      'absence'    => 3,
    }[state]
  end
end
