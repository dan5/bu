class UserEvent < ActiveRecord::Base
  attr_accessible :state

  belongs_to :user
  belongs_to :event
  validates_uniqueness_of :user_id, :scope => [:event_id]
end
